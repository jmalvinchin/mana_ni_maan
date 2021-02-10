require "rails_helper"

describe OrderForm do
  let(:product1) { create(:product) }
  let(:product2) { create(:product) }

  describe "#save" do
    context "successfully" do
      let(:baking_slot) { create(:baking_slot, max_slots: 3) }
      let(:params) do
        {
          first_name: "Hello",
          last_name: "World",
          paid: true,
          baking_slot_id: baking_slot.id,
          orders: [
            {
              quantity: 1,
              product_id: product1.id
            },
            {
              quantity: 2,
              product_id: product2.id
            }
          ]
        }
      end

      it "should save and allocate the order" do
        form = OrderForm.new(params)
        expect(form.save).to eq true

        expect(form.order.allocated?).to eq true
        expect(form.order.order_items.count).to eq 3
        expect(form.order.slot_count).to eq 3
      end
    end


    context "customer details" do
      let(:baking_slot) { create(:baking_slot, max_slots: 3) }
      let(:params) do
        {
          baking_slot_id: baking_slot.id,
          orders: [
            {
              quantity: 1,
              product_id: product1.id
            },
            {
              quantity: 2,
              product_id: product2.id
            }
          ]
        }.merge(user_hash)
      end

      context "using existing user_id" do
        let(:user) { create(:user, first_name: "Existing", last_name: "Customer") }
        let(:user_hash) do
          {
            user_id: user.id
          }
        end

        it "uses the existing user" do
          form = OrderForm.new(params)
          expect(form.save).to eq true

          expect(form.order.customer).to eq user
          expect(form.order.customer.first_name).to eq user.first_name
          expect(form.order.customer.last_name).to eq user.last_name
        end
      end

      context "using customer name" do
        let(:user_hash) do
          {
            first_name: "New",
            last_name: "Customer",
          }
        end

        it "uses the existing user" do
          form = OrderForm.new(params)
          expect(form.save).to eq true

          order = Order.first
          expect(form.order.customer).not_to be_nil
          expect(form.order.customer.first_name).not_to be_nil
          expect(form.order.customer.last_name).not_to be_nil
        end
      end
    end

    context "baking slot" do
      let(:baking_slot) { create(:baking_slot, max_slots: 2) }
      let(:params) do
        {
          first_name: "Hello",
          last_name: "World",
          paid: paid,
          baking_slot_id: baking_slot.id,
          orders: orders
        }
      end

      context "with order items greater than baking slot max" do
        let(:paid) { true }
        let(:orders) do
          [
            {
              quantity: 1,
              product_id: product1.id
            },
            {
              quantity: 2,
              product_id: product2.id
            }
          ]
        end
        it "was not successfully allocated" do
          form = OrderForm.new(params)
          expect(form.save).to eq true

          order = Order.first
          expect(form.order.allocated?).to eq false
          expect(form.order.baking_slot).to be_nil
        end
      end

      context "with unpaid order" do
        let(:paid) { false }
        let(:orders) do
          [
            {
              quantity: 1,
              product_id: product1.id
            },
            {
              quantity: 1,
              product_id: product2.id
            }
          ]
        end
        it "was not successfully allocated" do
          form = OrderForm.new(params)
          expect(form.save).to eq true

          order = Order.first
          expect(form.order.allocated?).to eq false
          expect(form.order.baking_slot).to be_nil
        end
      end
    end
  end
end
