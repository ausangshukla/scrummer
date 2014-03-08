class TasksController < InheritedResources::Base

  respond_to :html, :js
  
  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]

  def new
    @task.user = current_user
  end
  
  def task_board
    
  end
    
  def index
    if(params[:project_id].present?)
      @project = Project.find(params[:project_id])
      @tasks = @project.tasks
    elsif(params[:sprint_id].present?)
      @sprint = Sprint.find(params[:sprint_id])
      @project = @sprint.project  
      @tasks = @sprint.tasks          
    end
    
    if(params[:feature_id].present?)
        @tasks = @tasks.where(feature_id: params[:feature_id])
      end
    
    params[:tasks_for] = "My" if params[:tasks_for].blank? 
    if(params[:tasks_for] == "My")
      @tasks = @tasks.where(assigned_to: current_user.id)
    end
    if(params[:status].present?)
      @tasks = @tasks.where(status: params[:status])
    end
    
    @tasks = @tasks.includes(:user, :feature).order("users.last_name, tasks.id desc")
  end
  
      
  ALLOWED_FIELDS =
  [ :summary, :details, :notes, :status, :task_type, :assigned_to, 
    :project_id, :feature_id, :planned_hours, :actual_hours, :remaining_hours ]

  private

  def permitted_params
    params[:task] ? {:task => params.require(:task).permit(*ALLOWED_FIELDS)} : {:task=>nil}
  end

end
