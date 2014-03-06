class ProjectUserMappingsController < InheritedResources::Base
  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]   

  def index
    @project = Project.find(params[:project_id])
  end
  
  def create
    existing = ProjectUserMapping.where(user_id:@project_user_mapping.user_id, project_id: @project_user_mapping.project_id)
    existing.each(&:destroy) if existing
    
    if @project_user_mapping.save
      flash[:notice] = "Created team member successfully"
    else
      flash[:alert] = "Team member creation failed"
    end
    redirect_to :back
  end
  
  
  def destroy
    @project_user_mapping.destroy
    redirect_to :back
  end
    
  ALLOWED_FIELDS =
  [ :user_id, :project_id, :role ]
    
  private

  def permitted_params
    params[:project_user_mapping] ? {:project_user_mapping => params.require(:project_user_mapping).permit(*ALLOWED_FIELDS)} : {:project_user_mapping=>nil}
  end
  
  
end
