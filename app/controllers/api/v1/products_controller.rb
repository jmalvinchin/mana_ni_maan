class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render :show
    else
      render json: { errors: @product.errors.full_messages }
    end
  end

  private

  def product_params
    params.require(:product).permit(:name)
  end
end
