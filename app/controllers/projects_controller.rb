class ProjectsController < InheritedResources::Base

  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]
  
  def index
    @projects = @projects.includes(:project_user_mappings)
  end

  ALLOWED_FIELDS =
  [ :name, :start_date, :end_date, :status
  ]
  private

  def permitted_params
    params[:project] ? {:project => params.require(:project).permit(*ALLOWED_FIELDS)} : {:project=>nil}
  end
end
