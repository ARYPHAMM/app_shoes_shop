class Admins::ProductsController < BaseController
  before_action :set_product , only: [:edit,:update, :show,:destroy]
  #include ActiveModel::AttributeMethods
  def index
    @product = Product.all
  end

  def show

  end

  def destroy
    if @product.destroy
      flash[:success] = "Product was successfully deleted"
      redirect_to  admins_products_path
    else
      redirect_to  admins_homepage_path
    end
  end

  def new
    @product = Product.new
    @product.stocks.new
  end
  def create
    @product = Product.new(product_params)
    @product.images.attach(@product.resize_images(params[:product][:images]))
    @product.category_id = Brand.find(product_params[:brand_id]).category.id.to_i
    if @product.save
      flash[:success] = "Product was created successfully"
      redirect_to admins_products_path
      # debugger
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    @product.category_id = Brand.find(product_params[:brand_id]).category.id.to_i
        debugger

    @product.images.attach(@product.resize_images(params[:product][:images])) if params[:product][:images] != nil
    if @product.update(product_params)
      flash[:success] = "Product was updated"
      redirect_to edit_admins_product_path(@product)
    else
      render 'edit'
    end
  end

  def destroyimage
    if params[:product]
      @product = Product.find(params[:product])
      @product.images[params[:images].to_i].purge
    end
    redirect_to edit_admins_product_path(@product.id.to_i)
  end
  private

  def product_params
    params.require(:product).permit(:name,:customer, :price, :description, :brand_id, stocks_attributes: [:id,:size, :quantity, :_destroy])
  end

  def set_product
    if Product.exists? id: params[:id]
      @product = Product.find(params[:id])
    else
      redirect_to root_path
      flash[:danger] = "Product is not exist"
    end
  end
end
