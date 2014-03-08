module ApplicationHelper
  
  def jsonify text
    JSON.pretty_generate JSON.parse(text)
  rescue
    text
  end
  
  def active_tab_class(params, tabName, isDefault=false)
    cname = "inactive"
    if params[:tab].present? 
      if params[:tab] == tabName
        # tab passed and is this tabName
        cname = "active" 
      end
    elsif isDefault
      # no tab passsed and this tabName is the default
      cname = "active"
    end
    return cname
  end
  
  def active_menu(path)
    request.url.include?(path) ? "active open" : nil
  end
  
  def active_tab(tab, default=false)
    if params[:tab].present?    
      params[:tab] == tab ? "active open" : nil
    else
      default ? "active open" : nil
    end
  end
  
  def active_status(status)
    params[:status] == status ? "active open" : nil
  end

  def tb_icon_tag(label, icon_class,br="</br>")
    "<i class='#{icon_class}'></i>#{br}#{label}".html_safe
  end

  def tb_image_tag(label, image)
    image_tag(image) + "</br>#{label}".html_safe
  end

  def display_date(input_date)
    if input_date
      return input_date.strftime("%m/%d/%y")
    end
    return ""
  end

  def display_date_w_day(input_date)
    if input_date
      return input_date.strftime("%a, %b %d, %y")
    end
    return ""
  end

  def display_short_date(input_date)
    if input_date
      return input_date.strftime("%b %d, %y")
    end
    return ""
  end
  
  def display_mini_date(input_date)
     if input_date
       return input_date.strftime("%m %d")
     end
     return ""
   end

  def display_date_time(input_date)
    if input_date
      return input_date.strftime("%m/%d/%y %I:%M %p")
    end
    return ""
  end

  def display_time(input_time)
    if input_time
      return input_time.strftime("%I:%M %p")
    end
    return ""
  end

  def display_time_24(input_time)
    if input_time
      return input_time.strftime("%H:%M")
    end
    return ""
  end
  
  
  def get_date(arg)
    if arg.is_a?(String)
      if(arg.index('/'))
        # This format is sent by datepicker in the UI
        date = Date.strptime(arg, "%m/%d/%Y")
      else
        # We could not parse this date - so return nil
        date = nil
      end
    else #just push it through
      date = arg
    end

    return date
  end

  def display_phone(phone)
    
    if(phone)
      sanitized = phone.gsub(/\D*/, "")   
      
      if sanitized.to_i > 0 
        if sanitized.length <= 10 
          return number_to_phone(sanitized.to_i, :area_code => true, :delimiter=>" ")
        elsif sanitized.length == 11
          cc = sanitized.slice!(0)
          return number_to_phone(sanitized.to_i, :area_code => true, :delimiter=>" ", :country_code => cc)
        else
          return phone
        end
      else
        return phone
      end
    else
      return phone
    end
  end
  
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
  
  def risk_class(client)
    client.risk_level.downcase.gsub(" / ", "_").gsub(" ", "_")
  end
end

