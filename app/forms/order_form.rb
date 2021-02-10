class OrderForm
  attr_accessor :order

  def initialize(params)
    @params = params.to_h.deep_symbolize_keys
    @slot_count = 0
  end

  def save
    ActiveRecord::Base.transaction do
      @order = Order.new(paid: @params[:paid])
      @baking_slot = BakingSlot.find(@params[:baking_slot_id])

      attach_customer_details
      generate_order_items
      allocate_baking_slot

      save_baking_slot = @baking_slot.changed? ? @baking_slot.save : true
      @order.save && save_baking_slot
    end
  end

  private

  def attach_customer_details
    if @params[:user_id]
      @order.customer = User.find(@params[:user_id])
    else
      @order.customer = User.find_or_create_by(first_name: @params[:first_name], last_name: @params[:last_name])
    end
  end

  def generate_order_items
    @params[:orders].each do |order_item|
      quantity = order_item[:quantity].to_i

      @slot_count += quantity
      product = Product.find(order_item[:product_id])

      (1..quantity).each do |i|
        @order.order_items.build(product: product)
      end
    end

    @order.slot_count = @slot_count
  end

  def allocate_baking_slot
    updated_slots = @baking_slot.slot_count + @slot_count
    if @baking_slot && (updated_slots <= @baking_slot.max_slots) && @params[:paid]
      @order.order_items.each do |item|
        item.status = ORDER_STATUS[:allocated]
        item.baking_slot = @baking_slot
      end
      @baking_slot.slot_count = updated_slots
    end
  end
end
