require "spec_helper"

describe BillPreparesController do
  describe "routing" do

    it "routes to #index" do
      get("/bill_prepares").should route_to("bill_prepares#index")
    end

    it "routes to #new" do
      get("/bill_prepares/new").should route_to("bill_prepares#new")
    end

    it "routes to #show" do
      get("/bill_prepares/1").should route_to("bill_prepares#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bill_prepares/1/edit").should route_to("bill_prepares#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bill_prepares").should route_to("bill_prepares#create")
    end

    it "routes to #update" do
      put("/bill_prepares/1").should route_to("bill_prepares#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bill_prepares/1").should route_to("bill_prepares#destroy", :id => "1")
    end

  end
end
