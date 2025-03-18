# frozen_string_literal: true

require 'bunny'
require 'json'
require 'active_record'
require_relative 'config/environment'

# Configuración de conexión a RabbitMQ
conn = Bunny.new(hostname: 'rabbitmq') # El hostname es el nombre del contenedor RabbitMQ en Docker
conn.start

channel = conn.create_channel
queue = channel.queue('order_queue', durable: true)

puts "[*] Esperando mensajes en 'order_queue'. Para salir, presiona CTRL+C"

begin
  queue.subscribe(block: true, manual_ack: true) do |delivery_info, properties, body|
    data = JSON.parse(body)
    product_id = data['product_id']
    quantity = data['quantity']

    puts "[x] Procesando orden: Producto ID #{product_id}, Cantidad #{quantity}"

    # Buscar el producto en la base de datos
    product = Product.find_by(id: product_id)

    if product.nil?
      puts "[!] Producto no encontrado: ID #{product_id}"
      channel.basic_nack(delivery_info.delivery_tag)
      next
    end

    if product.quantity >= quantity
      # Reducir el stock del producto
      product.update(quantity: product.quantity - quantity)
      puts "[✓] Stock actualizado: #{product.name}, Nuevo stock: #{product.quantity}"

      # Enviar confirmación al sistema
      channel.default_exchange.publish(
        { status: 'success', product_id: product_id, message: 'Stock verificado y orden procesada' }.to_json,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )

      channel.basic_ack(delivery_info.delivery_tag) # Confirmar mensaje procesado
    else
      puts "[!] Stock insuficiente para #{product.name}"

      # Notificar a la app que no hay suficiente stock
      channel.default_exchange.publish(
        { status: 'error', product_id: product_id, message: 'Stock insuficiente' }.to_json,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )

      channel.basic_nack(delivery_info.delivery_tag) # Rechazar mensaje para reintento o manejo alternativo
    end
  rescue StandardError => e
    puts "[ERROR] Ocurrió un error: #{e.message}"
    puts e.backtrace
    channel.basic_nack(delivery_info.delivery_tag)
  end
rescue Interrupt
  puts "\n[*] Cerrando conexión con RabbitMQ..."
  conn.close
end
