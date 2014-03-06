module LayoutHelper
  
  
  def current_layout
    layout = self.send(:_layout)
    if layout.instance_of? String
      layout
    else
      File.basename(layout.identifier.split('.').first)
    end
  end


  def prepare_layout
    
    if params[:layout] 
      layout_name = params[:layout]
    else    
      if current_user
        layout_name = DEFAULT_LAYOUT
      else
        layout_name = "blank"
      end
    end        

    self.class.layout layout_name == "none" ? false : layout_name

  end
  
end
