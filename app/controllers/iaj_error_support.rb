module IajErrorSupport
  
  def render_error(exception)
    @error = exception
    logger.debug "render_error called with #{exception.message}"

    respond_to do |format|
      format.html {
        redirect_to "/404.html", :status => 404
      }
      format.js {
        @title = "Sorry! An error has occured"
        @msg = "An error has occured and we are looking into it right away. Please try again or report the error using the feedback link."
        render "layouts/alert"
      }
      
    end

  end

  def email_and_log_exception(e)
    # If someone is fishing for data using randomly generated ids then
    # This helps us redirect him to the home page
    if params[:action] == 'show' && e.kind_of?(ActiveRecord::RecordNotFound)
      access_denied(e)
      return
    end
    # mail it out

    request.env["CURRENT_USER"] = current_user.id if current_user

    Rails.application.config.filter_parameters.each do |filtered|

      if request.parameters[filtered].present?
        request.parameters[filtered] = "Filtered"
      end

    end

    log_exception_handler(e)

  end

  
  def access_denied(exception)
    @access_denied_exception = exception
    user_id = current_user ? current_user.id : "Anonymous"

    logger.info "Access denied for user #{user_id}"
    flash[:alert] = "Permission Denied. " + exception.message

    respond_to do |format|
      format.html {
        redirect_to root_url
      }
      format.js {
        @title = "Permission Denied"
        @msg = exception.message
        render "layouts/alert"
      }
      
    end
  end
end