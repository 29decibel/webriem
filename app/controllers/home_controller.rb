class HomeController < ApplicationController
  layout :false
  caches_page :index
  def index
  end

  def change_locale
    cookies['locale'] = params[:locale]
    redirect_to root_path
  end

end
