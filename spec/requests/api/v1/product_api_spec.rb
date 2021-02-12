require "rails_helper"

describe "Product API" do
  let!(:user) { create(:user) }
  let!(:auth_helpers_auth_token) { user.create_new_auth_token }

  describe "#index" do
    let!(:product) { create(:product) }
    let!(:order_item) { create(:order_item, product: product) }

    it "displays a list of products" do
      get "/api/v1/products"
      result = JSON.parse(response.body)
      expect(result.size).to eq 1

      product = result.first.deep_symbolize_keys
      expect(product[:id]).not_to be_nil
      expect(product[:name]).not_to be_nil
      expect(product[:order_items]).not_to be_empty
    end
  end
end
