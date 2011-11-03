require "spec_helper"

describe BillStagesController do
  describe "routing" do

    it "routes to #index" do
      get("/bill_stages").should route_to("bill_stages#index")
    end

    it "routes to #new" do
      get("/bill_stages/new").should route_to("bill_stages#new")
    end

    it "routes to #show" do
      get("/bill_stages/1").should route_to("bill_stages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bill_stages/1/edit").should route_to("bill_stages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bill_stages").should route_to("bill_stages#create")
    end

    it "routes to #update" do
      put("/bill_stages/1").should route_to("bill_stages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bill_stages/1").should route_to("bill_stages#destroy", :id => "1")
    end

  end
end
