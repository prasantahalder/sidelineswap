module ApplicationHelper
 def js_extract_messages_from_flash
    result = ""
    unless flash.empty?
      result = "<script language='javascript'>\n $(window).load(function() {\n"
      result << "Notifications.extractMessages(#{flash.to_json});\n});\n</script>";
      flash.discard
    end
    return result
  end

  def states_list
    Carmen::states('US') + Carmen::states('CA')
  end

  def country_list
    (['United States', 'Canada'] + Carmen.country_names).uniq
  end

  def sort_links (cols, options)
    out = cols.collect do |col|
      col_title = col[0]
      col_name = col[1]
      if col_name == params[:order] || (params[:order].blank? && col_name == options[:default])
        "<span disabled='disabled'>#{h col_title}</span>"
      else
        # this is fucking retarded. thank you rails.
        link_to(col_title, request.env['PATH_INFO'] + "?" + params.reject{|k,v|!['page','search'].include?(k)}.merge({:order => col_name}).to_query, :remote => true, :class => options[:class] )
      end
    end.join(' ').html_safe
  end
end
