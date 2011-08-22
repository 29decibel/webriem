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

  def register_demo
    demo_customer = DemoCustomer.create params[:demo_customer]
    Demo.notice(demo_customer.email).deliver
  end

  def apply_demo
    @demo_customer = DemoCustomer.new
    respond_to do |wants|
      wants.html { render :layout => false }
    end
  end
end
