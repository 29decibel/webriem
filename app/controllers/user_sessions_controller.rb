class UserSessionsController < Devise::SessionsController 
  def new
    respond_to do |wants|
      wants.html    
      wants.mobile
    end
  end
  
 def create
    respond_to do |wants|
      if current_user
        wants.html {redirect_to root_path}
        wants.mobile {redirect_to root_path}
        wants.js
      else
        wants.html { render 'new'}
        wants.mobile {render 'new'}
        wants.js { render 'error'}
      end
    end
  end
end
