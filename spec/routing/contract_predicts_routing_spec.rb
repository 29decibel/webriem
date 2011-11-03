require "spec_helper"

describe ContractPredictsController do
  describe "routing" do

    it "routes to #index" do
      get("/contract_predicts").should route_to("contract_predicts#index")
    end

    it "routes to #new" do
      get("/contract_predicts/new").should route_to("contract_predicts#new")
    end

    it "routes to #show" do
      get("/contract_predicts/1").should route_to("contract_predicts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/contract_predicts/1/edit").should route_to("contract_predicts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/contract_predicts").should route_to("contract_predicts#create")
    end

    it "routes to #update" do
      put("/contract_predicts/1").should route_to("contract_predicts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/contract_predicts/1").should route_to("contract_predicts#destroy", :id => "1")
    end

  end
end
