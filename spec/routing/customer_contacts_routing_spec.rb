require "spec_helper"

describe CustomerContactsController do
  describe "routing" do

    it "routes to #index" do
      get("/customer_contacts").should route_to("customer_contacts#index")
    end

    it "routes to #new" do
      get("/customer_contacts/new").should route_to("customer_contacts#new")
    end

    it "routes to #show" do
      get("/customer_contacts/1").should route_to("customer_contacts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/customer_contacts/1/edit").should route_to("customer_contacts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/customer_contacts").should route_to("customer_contacts#create")
    end

    it "routes to #update" do
      put("/customer_contacts/1").should route_to("customer_contacts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/customer_contacts/1").should route_to("customer_contacts#destroy", :id => "1")
    end

  end
end
