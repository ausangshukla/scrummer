class ProjectsController < InheritedResources::Base

  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]
  
  def index
    @projects = @projects.includes(:project_user_mappings)
  end
  
  def create
    
    if @project.save
      @project.project_user_mappings << ProjectUserMapping.new(user_id: current_user.id, role: current_user.role)
      flash[:notice] = "Successfully created project"
      redirect_to projects_path
    else
      logger.debug @project.errors.full_messages
      render "new"
    end
  end

  ALLOWED_FIELDS =
  [ :name, :start_date, :end_date, :status
  ]
  private

  def permitted_params
    params[:project] ? {:project => params.require(:project).permit(*ALLOWED_FIELDS)} : {:project=>nil}
  end
end
