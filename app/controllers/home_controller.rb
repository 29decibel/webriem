class HomeController < ApplicationController
  layout :false
  caches_page :index
  def index
  end

end
