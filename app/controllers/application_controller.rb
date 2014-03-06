class ApplicationController < ActionController::Base
  
  include LayoutHelper
  before_filter :prepare_layout
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  
  layout DEFAULT_LAYOUT

  # All the error routing / 404 logic is refactored into IajErrorSupport
  include ExceptionLogger::ExceptionLoggable
  include IajErrorSupport
  
  rescue_from Exception, :with => :email_and_log_exception # if Rails.env != "development"
  rescue_from CanCan::AccessDenied do |exception|
    access_denied(exception)
  end


  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || "/" #"/dashboard"
  end

  def after_sign_up_path_for(resource_or_scope)
    root_path
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    root_path    
  end

end
