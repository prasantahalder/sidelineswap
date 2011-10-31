class TeamsController < ApplicationController
  resources_controller_for :teams
  
  def ac   
    @query = params[:query]
    @query.gsub!(/%/, '')
    @search = Team.where(:name.matches => "#{@query}%")
    @search.limit(10)
    @search.order(:name)

    output = {:query => @query, 
      :suggestions => @search.collect{|t| "#{t.name} (#{t.country})"},
      :data => @search.collect{|t| t.id}      
    }
    render :json => output
  end

  def short
    @team = find_resource
    @object_name = params[:obj]
    if params[:single]
      render :partial => 'short_single', :locals => {:team => @team, :object_name => @object_name}
    else
      render :partial => 'short', :locals => {:team => @team, :object_name => @object_name}
    end
  end

end
