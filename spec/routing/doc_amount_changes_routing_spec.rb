require "spec_helper"

describe DocAmountChangesController do
  describe "routing" do

    it "routes to #index" do
      get("/doc_amount_changes").should route_to("doc_amount_changes#index")
    end

    it "routes to #new" do
      get("/doc_amount_changes/new").should route_to("doc_amount_changes#new")
    end

    it "routes to #show" do
      get("/doc_amount_changes/1").should route_to("doc_amount_changes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/doc_amount_changes/1/edit").should route_to("doc_amount_changes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/doc_amount_changes").should route_to("doc_amount_changes#create")
    end

    it "routes to #update" do
      put("/doc_amount_changes/1").should route_to("doc_amount_changes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/doc_amount_changes/1").should route_to("doc_amount_changes#destroy", :id => "1")
    end

  end
end
