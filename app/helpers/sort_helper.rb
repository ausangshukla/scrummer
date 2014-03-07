module SortHelper
  
  def sortable(column, title=nil, tab=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if params[:client_id].present?
      link_to title, client_path(:id=>params[:client_id], :tab=>tab, :sort => column, :direction => direction), {:class => css_class}
    else
      link_to title, params.merge({:sort => column, :direction => direction}), {:class => css_class}
    end
  end
  

  def sort_column(table_name=nil)
    def_sort_col = table_name ? table_name + ".id" : "id"
    params[:sort].present? ? "#{params[:sort]}" : def_sort_col
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end