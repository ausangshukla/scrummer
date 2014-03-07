class FeaturesController < InheritedResources::Base
  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]   
    
    
  def index
    if(params[:project_id].present?)
      @project = Project.find(params[:project_id])
      @features = @project.features
    end
    
    @features = @features.includes(:project, :sprint).order("sprints.iteration asc, features.priority asc")
  end

  ALLOWED_FIELDS =
  [ :summary, :details, :acceptance_criteria, :project_id, :sprint_id, :status, :priority, 
    :points, :classification, :assigned_to ]
    
  private

  def permitted_params
    params[:feature] ? {:feature => params.require(:feature).permit(*ALLOWED_FIELDS)} : {:feature=>nil}
  end
end
