require "rails_helper"

describe "Baking Slot API", type: :request do
  context "#index" do
    let!(:baking_slot) { create(:baking_slot) }

    it "retrieves list of baking slots" do
      get "/api/v1/baking_slots"

      expect(response.status).to be 200

      results = JSON.parse(response.body)
      baking_slot = results[0]
      expect(baking_slot["id"]).not_to be_nil
      expect(baking_slot["slot"]).not_to be_nil
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