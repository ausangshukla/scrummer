class UsersController < InheritedResources::Base

  before_filter :authenticate_user!, :except=>[]
  load_and_authorize_resource :except=>[]
    
  def search
    per_page = params[:per_page] ? params[:per_page].to_i : 20
    per_page = 100000 if params[:all].present?

     @users = User.search Riddle.escape(params[:term].gsub("@","")),  :star => true
     
    respond_to do |format|
      format.html  { render "index" }
      format.json  { render :json=>@users.to_json }
    end    
  end

  ALLOWED_FIELDS =
  [ :first_name, :last_name, :role, :active,
    :email, :phone, :password, :password_confirmation, :current_password
  ]
  private

  def permitted_params
    params[:user] ? {:user => params.require(:user).permit(*ALLOWED_FIELDS)} : {:user=>nil}
  end
end
