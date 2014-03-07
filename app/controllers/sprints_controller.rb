class SprintsController < InheritedResources::Base

  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]
  
  def index
    if(params[:project_id].present?)
      @project = Project.find(params[:project_id])
      @sprints = @project.sprints
    end
  end
    
  def new
    prev_sprint = Sprint.where(project_id:@sprint.project_id).order("iteration asc").last
    if prev_sprint    
      @sprint.iteration = prev_sprint.iteration + 1
      @sprint.start_date = prev_sprint.end_date + 1.day
      @sprint.end_date = @sprint.start_date + (prev_sprint.end_date - prev_sprint.start_date).days
    else
      @sprint.iteration = 1
      @sprint.start_date = Date.today
      @sprint.end_date = @sprint.start_date + 30.days
    end  
  end
  
  ALLOWED_FIELDS =
  [ :iteration, :start_date, :end_date, :notes, :rag_status, :project_id ]

  private

  def permitted_params
    params[:sprint] ? {:sprint => params.require(:sprint).permit(*ALLOWED_FIELDS)} : {:sprint=>nil}
  end

end
