class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_admin
    if !current_user or !current_user.is_admin
      redirect_to :controller => 'index', :action => 'index'
    end
  end 

end
