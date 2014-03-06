ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.qa?
ActionMailer::Base.default :from => ENV["SUPPORT_EMAIL"]
