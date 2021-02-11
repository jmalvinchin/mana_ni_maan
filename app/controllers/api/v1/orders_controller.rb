class Api::V1::OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @form = OrderForm.new(order_params)
    if @form.save
      @order = @form.order
      render :show
    else
      render json: { errors: @form.order.errors.full_messages }
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :user_id,
      :first_name,
      :last_name,
      :paid,
      :baking_slot_id,
      orders: [
        :quantity, :product_id
      ]
    )
  end
end
