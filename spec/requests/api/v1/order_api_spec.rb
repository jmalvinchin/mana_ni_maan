require "rails_helper"

describe "Order API" do
  context "#create" do
    let(:baking_slot) { create(:baking_slot, max_slots: 3) }
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }
    let(:params) do
      {
        order: {
          first_name: "Hello",
          last_name: "World",
          baking_slot_id: baking_slot.id,
          paid: true,
          orders: [
            {
              quantity: 1,
              product_id: product1.id
            },
            {
              quantity: 2,
              product_id: product2.id
            },
          ]

        }
      }

    end

    it "creates an order" do
      post "/api/v1/orders", params: params
      order = JSON.parse(response.body).deep_symbolize_keys

      expect(order[:id]).not_to be_nil

      order_baking_slot = order[:baking_slot]
      expect(order_baking_slot[:id]).not_to be_nil
      expect(order_baking_slot[:slot_count]).not_to be_nil
      expect(order_baking_slot[:max_slots]).not_to be_nil

      expect(order[:customer]).not_to be_nil

      expect(order[:order_items].size).to eq 3
      order_item = order[:order_items].first
      expect(order_item[:baking_slot]).not_to be_nil
      expect(order_item[:status]).to eq ORDER_STATUS[:allocated]
      expect(order_item[:order_id]).not_to be_nil

      expect(order[:order_breakdown].size).to eq 2
      order_breakdown = order[:order_breakdown].first
      expect(order_breakdown[:name]).not_to be_nil
      expect(order_breakdown[:quantity]).not_to be_nil
    end
  end
end
