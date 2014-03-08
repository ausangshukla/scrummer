class FeaturesController < InheritedResources::Base
  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]   
    
    
  def index
    if(params[:sprint_id].present?)
      @sprint = Sprint.find(params[:sprint_id])
      @features = @sprint.features
      @project = @sprint.project
    elsif(params[:project_id].present?)
      @project = Project.find(params[:project_id])
      @features = @project.features
    end
    
    @features = @features.includes(:sprint, :user, :project=>[:project_user_mappings]).order("sprints.iteration asc, features.priority asc")
  end

  ALLOWED_FIELDS =
  [ :summary, :details, :acceptance_criteria, :project_id, :sprint_id, :feature_type, :status, :priority, 
    :points, :classification, :assigned_to ]
    
  private

  def permitted_params
    params[:feature] ? {:feature => params.require(:feature).permit(*ALLOWED_FIELDS)} : {:feature=>nil}
  end
end
