require "rails_helper"

describe "Order API" do
  let!(:user) { create(:user) }
  let!(:auth_helpers_auth_token) { user.create_new_auth_token }

  context "#index" do
    let!(:order) { create(:order, slot_count: 1) }
    let!(:order_item) { create(:order_item, order: order) }

    it "displays a list of orders" do
      get "/api/v1/orders"
      result = JSON.parse(response.body)
      expect(result.size).to eq 1

      order = result.first.deep_symbolize_keys
      expect(order[:id]).not_to be_nil
      expect(order[:customer]).not_to be_nil

      expect(order[:order_items].size).to eq 1
      order_item = order[:order_items].first
      expect(order_item[:baking_slot]).not_to be_nil
      expect(order_item[:status]).to eq ORDER_STATUS[:pending]
      expect(order_item[:order_id]).not_to be_nil

      expect(order[:order_breakdown].size).to eq 1
      order_breakdown = order[:order_breakdown].first
      expect(order_breakdown[:name]).not_to be_nil
      expect(order_breakdown[:quantity]).not_to be_nil
    end

    context "filters" do
      let!(:new_order) { create(:order, slot_count: 1, paid: false) }
      let!(:order_item) { create(:order_item, status: ORDER_STATUS[:allocated], order: new_order) }

      describe "#reference_code" do
        it "returns the filtered results successfully" do
          get "/api/v1/orders", params: { reference_code: new_order.reference_code }
          result = JSON.parse(response.body)
          expect(result.size).to eq 1

          order = result.first.deep_symbolize_keys
          expect(order[:id]).to eq new_order.id
        end
      end

      describe "#slot_count" do
        it "returns the filtered results successfully" do
          get "/api/v1/orders", params: { slot_count: 1 }
          result = JSON.parse(response.body)
          expect(result.size).to eq 2

          order = result.first.deep_symbolize_keys
          expect(order[:id]).not_to be_nil
        end
      end

      describe "#paid" do
        it "returns the filtered results successfully" do
          get "/api/v1/orders", params: { paid: false }
          result = JSON.parse(response.body)
          expect(result.size).to eq 1

          order = result.first.deep_symbolize_keys
          expect(order[:id]).to eq new_order.id
        end
      end

      describe "#customer_id" do
        it "returns the filtered results successfully" do
          get "/api/v1/orders", params: { customer_id: new_order.customer_id }
          result = JSON.parse(response.body)
          expect(result.size).to eq 1

          order = result.first.deep_symbolize_keys
          expect(order[:id]).to eq new_order.id
        end
      end
      
      context "allocated" do
        let(:order_item) { create(:order_item, status: ORDER_STATUS[:allocated], order: new_order) }

        it "returns the filtered results successfully" do
          get "/api/v1/orders", params: { allocated: true }
          result = JSON.parse(response.body)
          expect(result.size).to eq 1

          order = result.first.deep_symbolize_keys
          expect(order[:id]).to eq new_order.id
        end
      end

      context "chain" do
        it "returns the filtered results sucessfully" do
          get "/api/v1/orders", params: { slot_count: 1, paid: false, allocated: true }
          result = JSON.parse(response.body)
          expect(result.size).to eq 1

          order = result.first.deep_symbolize_keys
          expect(order[:id]).to eq new_order.id
        end
      end
    end
  end

  context "#show" do
    let!(:order) { create(:order) }
    let!(:order_item) { create(:order_item, order: order) }

    it "displays the order" do
      get "/api/v1/orders/#{order.id}"
      order = JSON.parse(response.body).deep_symbolize_keys
      expect(order[:id]).not_to be_nil
      expect(order[:customer]).not_to be_nil

      expect(order[:order_items].size).to eq 1
      order_item = order[:order_items].first
      expect(order_item[:baking_slot]).not_to be_nil
      expect(order_item[:status]).to eq ORDER_STATUS[:pending]
      expect(order_item[:order_id]).not_to be_nil

      expect(order[:order_breakdown].size).to eq 1
      order_breakdown = order[:order_breakdown].first
      expect(order_breakdown[:name]).not_to be_nil
      expect(order_breakdown[:quantity]).not_to be_nil
    end
  end

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
