require "rails_helper"

describe Order do
  describe "#generate_reference_code" do
    let(:order) { create(:order) }
    let(:new_order) { create(:order) }

    it "should create an order with a different ref code" do
      expect(new_order.persisted?).to eq true
      expect(new_order.reference_code).not_to eq order.reference_code
    end
  end
end
