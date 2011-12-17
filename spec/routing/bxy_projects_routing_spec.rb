require "spec_helper"

describe BxyProjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/bxy_projects").should route_to("bxy_projects#index")
    end

    it "routes to #new" do
      get("/bxy_projects/new").should route_to("bxy_projects#new")
    end

    it "routes to #show" do
      get("/bxy_projects/1").should route_to("bxy_projects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bxy_projects/1/edit").should route_to("bxy_projects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bxy_projects").should route_to("bxy_projects#create")
    end

    it "routes to #update" do
      put("/bxy_projects/1").should route_to("bxy_projects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bxy_projects/1").should route_to("bxy_projects#destroy", :id => "1")
    end

  end
end
