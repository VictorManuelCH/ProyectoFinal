class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authorize_admin, only: [:edit, :update, :destroy]

  # GET /products or /products.json
  def index
    @products = Product.includes(:categories).all
    @q = Product.ransack(params[:q])  # Inicializa el objeto de búsqueda
    @products = @q.result(distinct: true)  # Obtén los productos según la búsqueda
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all
  end

  # GET /products/1/edit
  def edit
    @categories = Category.all
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
  
    # Si se ha ingresado una nueva categoría
    if params[:new_category].present? && params[:new_category] != ""
      @category = Category.find_or_create_by(name: params[:new_category])
      @product.categories << @category
    end
  
    # Intentamos guardar el producto
    if @product.save
      redirect_to @product, notice: 'Producto creado exitosamente.'
    else
      @categories = Category.all
      render :new
    end
  end
  

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.product_categories.destroy_all # Elimina las asociaciones en product_categories
    @product.destroy # Luego elimina el producto

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      if @product.nil?
        redirect_to products_path, alert: "Producto no encontrado."
      end
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :quantity, category_ids: [], images: [])
    end

    def authorize_admin
      unless current_user&.administrador?
        redirect_to root_path, alert: "No tienes permiso para realizar esta acción"
      end
    end
    
    
end
