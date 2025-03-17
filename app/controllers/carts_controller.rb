class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show edit update destroy ]

  # GET /carts or /carts.json
  def index
    @carts = Cart.all
  end

  # def checkout
  #   @cart = current_user.cart
    
  #   # Llamar a la función para verificar stock y redirigir
  #   verify_stock_and_redirect
  # end

  # def verify_stock_and_redirect
  #   @cart = current_user.cart # O cualquier otra forma de obtener el carrito del usuario
  
  #   # Verificar si hay suficiente stock para los productos del carrito
  #   @cart.cart_products.each do |cart_product|
  #     product = cart_product.product
  
  #     # Verifica que haya suficiente cantidad en stock
  #     if product.quantity < cart_product.quantity
  #       flash[:alert] = "No hay suficiente stock para algunos productos."
  #       redirect_to cart_path and return
  #     end
  #   end
  
  #   # Si todo está bien, redirige al formulario de selección de método de pago
  #   payment_confirmation_cart_path
  # end
  

  def checkout
    sleep(5)
    @cart = current_user.cart
  
    # Busca o crea un pedido asociado al carrito
    order = @cart.order || Order.create(
      user: current_user,
      cart: @cart,
      total_price: @cart.total_price
    )
  
    # Crea el pago asociado al pedido
    @payment = Payment.create(
      order: order,
      total_amount: order.total_price,
      payment_state: PaymentState.find_or_create_by(name: 'Confirmado'),
      payment_method: PaymentMethod.first # Cambia según tus datos
    )
  
    if @payment.persisted?
      # Reducir el inventario de cada producto en el carrito
      @cart.cart_products.each do |cart_product|
        product = cart_product.product
  
        # Verifica que haya suficiente cantidad y reduce el inventario
        if product.quantity >= cart_product.quantity
          product.update(quantity: product.quantity - cart_product.quantity)
        else
          # Si no hay suficiente stock, muestra un error
          flash[:alert] = "No hay suficiente stock para algunos productos."
          redirect_to cart_path and return
        end
      end

      Rails.logger.debug "Redirigiendo a /cart/payment_confirmation"
  
      redirect_to payment_confirmation_cart_path, notice: 'Pago realizado correctamente.'
    else
      redirect_to cart_path, alert: 'Hubo un problema al procesar el pago.'
    end
  end

  # def checkout
  #   #sleep(5)
  #   @cart = current_user.cart
  
  #   order = nil
  #   payment = nil
  
  #   ActiveRecord::Base.transaction do
  #     order = @cart.order || Order.create!(
  #       user: current_user,
  #       cart: @cart,
  #       total_price: @cart.total_price
  #     )
  
  #     payment = Payment.create!(
  #       order: order,
  #       total_amount: order.total_price,
  #       payment_state: PaymentState.find_or_create_by(name: 'Pendiente'),
  #       payment_method: PaymentMethod.first
  #     )
  
  #     # Reducir stock dentro de la transacción
  #     @cart.cart_products.each do |cart_product|
  #       product = cart_product.product
  
  #       if product.quantity >= cart_product.quantity
  #         product.update!(quantity: product.quantity - cart_product.quantity)
  #       else
  #         raise ActiveRecord::Rollback, "Stock insuficiente para #{product.name}"
  #       end
  #     end
  #   end
  
  #   # Enviar el mensaje a RabbitMQ después de que se completó la transacción
  #   enviar_a_rabbitmq(order)
  
  #   Rails.logger.debug "Redirigiendo a /cart/payment_confirmation"
  #   redirect_to payment_confirmation_cart_path, notice: 'Pago en proceso...'
  
  # rescue => e
  #   Rails.logger.error "Error en checkout: #{e.message}"
  #   redirect_to cart_path, alert: 'Hubo un problema al procesar el pago.'
  # end
  
  # def enviar_a_rabbitmq(order)
  #   connection = Bunny.new
  #   connection.start
  
  #   channel = connection.create_channel
  #   queue = channel.queue('procesar_pago')
  
  #   mensaje = {
  #     order_id: order.id,
  #     total_price: order.total_price.to_f,  
  #     productos: order.cart.cart_products.map do |cp|
  #       {
  #         nombre: cp.product.name,
  #         cantidad: cp.quantity,
  #         precio: cp.product.price.to_f 
  #       }
  #     end
  #   }.to_json
  
  #   puts "Mensaje enviado a RabbitMQ: #{mensaje}"  
  
  #   queue.publish(mensaje, persistent: true)
  
  #   connection.close
  # end

  

  #Primera conexion con el consumidor
  #CONSUMIDOR: ORDER CONSUMER
  # def publish_order_to_queue(order)
  #   connection = Bunny.new(hostname: ENV['RABBITMQ_HOST'] || 'rabbitmq')

  #   connection.start
  #   channel = connection.create_channel
  #   queue = channel.queue('order_queue')

  #   order_data = {
  #     order_id: order.id,
  #     user_id: order.user.id,
  #     total_price: order.total_price,
  #     products: order.cart.cart_products.map do |cart_product|
  #       {
  #         product_id: cart_product.product.id,
  #         name: cart_product.product.name,
  #         quantity: cart_product.quantity
  #       }
  #     end
  #   }

  #   queue.publish(order_data.to_json, persistent: true)
  #   puts " [x] Pedido enviado a la cola: #{order_data}"

  #   connection.close
  # end
  
  def payment_confirmation
    @cart = current_user.cart
    @payment = @cart.order&.payment # Asegúrate de que @payment se asigne correctamente desde el pedido del carrito
  
    unless @payment
      redirect_to cart_path, alert: 'No se encontró el pago asociado.'
    end
  end

  # def add_product
  #   product_id = params[:product_id].to_i
  #   quantity = params[:quantity].to_i
  
  #   if product_id <= 0 || quantity <= 0
  #     redirect_to root_path, alert: 'Producto o cantidad no válidos.'
  #     return
  #   end
  
  #   # Publicar mensaje en RabbitMQ
  #   response = check_stock_with_rabbitmq(product_id, quantity)
  
  #   if response["available"]
  #     if user_signed_in?
  #       @cart = current_user.cart || current_user.create_cart
  #       cart_product = @cart.cart_products.find_or_initialize_by(product_id: product_id)
  #       cart_product.quantity ||= 0
  #       cart_product.quantity += quantity
  
  #       if cart_product.save
  #         redirect_to cart_path, notice: 'Producto añadido al carrito.'
  #       else
  #         redirect_to cart_path(product_id), alert: 'No se pudo añadir el producto al carrito.'
  #       end
  #     else
  #       session[:cart] ||= {}
  #       session[:cart][product_id.to_s] ||= 0
  #       session[:cart][product_id.to_s] += quantity
  #       redirect_to cart_path, notice: 'Producto añadido al carrito.'
  #     end
  #   else
  #     redirect_to cart_path, alert: 'No hay suficiente stock disponible.'
  #   end
  # end
  
  # #PRIMER CONSUMIDOR: ORDEN_CONSUMER
  # def check_stock_with_rabbitmq(product_id, quantity)
  #   connection = Bunny.new(ENV['RABBITMQ_URL'])
  #   connection.start
  #   channel = connection.create_channel
  #   queue = channel.queue('stock_check', durable: true)
  
  #   response_queue = channel.queue('', exclusive: true)
  #   correlation_id = SecureRandom.uuid
  
  #   exchange = channel.default_exchange
  #   exchange.publish(
  #     { product_id: product_id, quantity: quantity }.to_json,
  #     routing_key: 'stock_check',
  #     reply_to: response_queue.name,
  #     correlation_id: correlation_id
  #   )
  
  #   puts "Mensaje enviado: #{product_id}, #{quantity}, Correlation ID: #{correlation_id}"
  
  #   response = nil
  #   response_queue.subscribe(block: true) do |delivery_info, properties, body|
  #     puts "Respuesta recibida: #{body}, Correlation ID: #{properties.correlation_id}"
  #     if properties.correlation_id == correlation_id
  #       response = JSON.parse(body)
  #       delivery_info.consumer.cancel
  #     end
  #   end
  
  #   connection.close
  #   response
  # end
  

  def add_product
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i
  
    # Verificar que product_id y quantity no sean nulos o incorrectos
    if product_id <= 0 || quantity <= 0
      redirect_to root_path, alert: 'Producto o cantidad no válidos.'
      return
    end
  
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
  
      # Si el carrito no existe, se crea uno nuevo
      cart_product = @cart.cart_products.find_or_initialize_by(product_id: product_id)
      cart_product.quantity ||= 0
      cart_product.quantity += quantity
  
      # Validar cantidad
      product = cart_product.product

      # Asegúrate de que product.quantity no sea nil
      available_stock = product.quantity || 0

      # Verificar si la cantidad en el carrito es mayor que el stock disponible
      if cart_product.quantity > available_stock
        redirect_to cart_path(product_id), alert: 'No hay suficiente stock de este producto.'
        return
      end

      if cart_product.quantity > product.quantity
        redirect_to cart_path(product_id), alert: 'No hay suficiente stock de este producto.'
        return
      end
  
      if cart_product.save
        redirect_to cart_path, notice: 'Producto añadido al carrito.'
      else
        redirect_to cart_path(product_id), alert: 'No se pudo añadir el producto al carrito.'
      end
    else
      # Lógica para usuarios no autenticados
      session[:cart] ||= {}
      session[:cart][product_id.to_s] ||= 0
      session[:cart][product_id.to_s] += quantity
      redirect_to cart_path, notice: 'Producto añadido al carrito.'
    end
  end
  
  
  # Eliminar un producto del carrito
  def remove_product
    product_id = params[:product_id].to_i
  
    if user_signed_in?
      # Lógica para usuarios registrados
      @cart = current_user.cart || current_user.create_cart
      cart_product = @cart.cart_products.find_by(product_id: product_id)
  
      if cart_product
        cart_product.destroy
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'El producto no estaba en tu carrito.'
      end
    else
      # Lógica para usuarios no autenticados, usando la sesión
      if session[:cart].present? && session[:cart][product_id.to_s].present?
        session[:cart].delete(product_id.to_s)
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'No hay productos en el carrito para eliminar.'
      end
    end
  end

  def update_quantity
    product_id = params[:product_id].to_i
    new_quantity = params[:quantity].to_i
  
    if user_signed_in?
      # Carrito para usuario registrado
      cart_product = @cart.cart_products.find_by(product_id: product_id)
      if cart_product
        cart_product.update(quantity: new_quantity)
        redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
      else
        redirect_to cart_path, alert: 'Producto no encontrado en el carrito.'
      end
    else
      # Carrito basado en sesión
      session[:cart][product_id] = new_quantity
      redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
    end
  end

  def remove_product2
    product_id = params[:product_id].to_i
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
      cart_product = @cart.cart_products.find_by(product_id: product_id)
      if cart_product
        cart_product.destroy
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'El producto no estaba en tu carrito.'
      end
    else
      # Lógica para usuarios no autenticados
      if session[:cart].present? && session[:cart][product_id.to_s].present?
        session[:cart].delete(product_id.to_s)
        redirect_to cart_path, notice: 'Producto eliminado del carrito.'
      else
        redirect_to cart_path, alert: 'No hay productos en el carrito para eliminar.'
      end
    end
  end
  
  def update_quantity2
    product_id = params[:product_id].to_i
    new_quantity = params[:quantity].to_i
  
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
      cart_product = @cart.cart_products.find_by(product_id: product_id)
      if cart_product
        cart_product.update(quantity: new_quantity)
        redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
      else
        redirect_to cart_path, alert: 'Producto no encontrado en el carrito.'
      end
    else
      # Carrito basado en sesión
      session[:cart][product_id] = new_quantity
      redirect_to cart_path, notice: 'Cantidad actualizada correctamente.'
    end
  end
  

  # GET /carts/1 or /carts/1.json
  
  def show
    @payment_methods = PaymentMethod.all
    @cart_items = session[:cart] || {}
    @products = Product.find(@cart_items.keys) # Asegúrate de que todos los productos existen
    
    # Calcular el total del carrito
    @total = @products.sum do |product|
      quantity = @cart_items[product.id.to_s] || 0
      product.price * quantity
    end
  end
  


  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts or /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: "Cart was successfully created." }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to carts_path, status: :see_other, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      if user_signed_in?
        # Carrito para usuario registrado
        @cart = current_user.cart || current_user.create_cart
        @cart_items = @cart.cart_products
      else
        # Carrito basado en sesión para usuarios no autenticados
        session[:cart] ||= {}
        @cart = OpenStruct.new(cart_products: session[:cart].map do |product_id, quantity|
          product = Product.find(product_id)
          OpenStruct.new(product: product, quantity: quantity, subtotal: product.price * quantity)
        end)
      end
    end    
    
  
    def user_signed_in?
      # Usa el método de autenticación que estés utilizando (por ejemplo, Devise)
      current_user.present?
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:user_id)
    end
end
