require "rails_helper"

describe "Baking Slot API", type: :request do
  let!(:user) { create(:user) }
  let!(:auth_helpers_auth_token) { user.create_new_auth_token }

  context "#index" do
    let!(:baking_slot) { create(:baking_slot, slot: DateTime.new(2099, 1, 1, 9)) }

    it "retrieves list of baking slots" do
      get "/api/v1/baking_slots"

      expect(response.status).to eq 200

      results = JSON.parse(response.body)
      baking_slot = results[0]
      expect(baking_slot["id"]).not_to be_nil
      expect(baking_slot["slot"]).not_to be_nil
    end

    context "filters" do
      let!(:baking_slot) { create(:baking_slot, slot: DateTime.new(2099, 1, 1, 15)) }

      it "filters baking slot via slot" do
        get "/api/v1/baking_slots", params: { slot: "2099-0l-01 03:00 PM" }

        expect(response.status).to eq 200

        results = JSON.parse(response.body)
        baking_slot = results[0]
        expect(baking_slot["id"]).not_to be_nil
        expect(baking_slot["slot"]).not_to be_nil
      end
    end
  end

  context "#create" do
    let(:params) do 
      { baking_slot: { slot: "2050-01-01 9:00:00" } }
    end

    it "creates a baking slot" do
      post "/api/v1/baking_slots", params: params
      baking_slot = JSON.parse(response.body)
      expect(baking_slot["id"]).not_to be_nil
      expect(baking_slot["slot"]).not_to be_nil
    end
  end
end
