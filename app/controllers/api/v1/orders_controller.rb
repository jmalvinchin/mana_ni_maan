class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    filter_params = params.slice(
      :reference_code,
      :slot_count,
      :paid,
      :customer_id,
      :allocated
    )

    @orders = Order.filter(filter_params)
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
      :customer_id,
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
