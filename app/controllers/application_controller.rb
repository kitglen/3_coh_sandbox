class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery

  
  
  ###
  ## Authorization
  #
  
  def current_user_role
    
      "Unauthenticated Default"
    
  end
  
  def reject_as_unauthorized
    render :nothing => true, :status => :unauthorized
  end
  
  protected
  def layout_by_resource
    if devise_controller?
      "admin"
    else
      "application"
    end
  end
end