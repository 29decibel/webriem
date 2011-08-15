class HomeController < ApplicationController
  layout "product"
  caches_page :index
  def index
  end

  def deployment
    
  end

  def contact_us
    
  end

  def change_locale
    cookies['locale'] = params[:locale]
    redirect_to root_path
  end

end
