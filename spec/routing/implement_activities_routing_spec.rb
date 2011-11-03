require "spec_helper"

describe ImplementActivitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/implement_activities").should route_to("implement_activities#index")
    end

    it "routes to #new" do
      get("/implement_activities/new").should route_to("implement_activities#new")
    end

    it "routes to #show" do
      get("/implement_activities/1").should route_to("implement_activities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/implement_activities/1/edit").should route_to("implement_activities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/implement_activities").should route_to("implement_activities#create")
    end

    it "routes to #update" do
      put("/implement_activities/1").should route_to("implement_activities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/implement_activities/1").should route_to("implement_activities#destroy", :id => "1")
    end

  end
end
