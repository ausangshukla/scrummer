class TasksController < InheritedResources::Base

  respond_to :html, :js
  
  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]

  def new
    @task.user = current_user
  end
    
  def index
    if(params[:project_id].present?)
      @project = Project.find(params[:project_id])
      @tasks = @project.tasks
    end
  end
  
      
  ALLOWED_FIELDS =
  [ :summary, :details, :notes, :status, :task_type, :assigned_to, 
    :project_id, :feature_id, :planned_hours, :actual_hours, :remaining_hours ]

  private

  def permitted_params
    params[:task] ? {:task => params.require(:task).permit(*ALLOWED_FIELDS)} : {:task=>nil}
  end

end
