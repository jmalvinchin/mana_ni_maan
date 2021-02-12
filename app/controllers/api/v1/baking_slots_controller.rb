class Api::V1::BakingSlotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @baking_slots = BakingSlot.all
  end

  def show
    @baking_slot = BakingSlot.find(params[:id])
  end

  def create
    @baking_slot = BakingSlot.new(baking_slot_params)
    if @baking_slot.save
      render :show
    else
      render json: { errors: @baking_slot.errors.full_messages }
    end
  end

  private

  def baking_slot_params
    params.require(:baking_slot).permit(:slot)
  end
end

