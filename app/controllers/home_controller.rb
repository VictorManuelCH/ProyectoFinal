class HomeController < ApplicationController
  def index
    @q = Product.ransack(params[:q])  # Inicializa el objeto de búsqueda
    @products = @q.result(distinct: true)  # Obtén los productos según la búsqueda
  end
end
