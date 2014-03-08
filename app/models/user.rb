class User < ActiveRecord::Base
  
  ROLES = ENV["USER_ROLES"].split(",")
  MANAGERS = ENV["MANAGERS"].split(",")
  MEMBERS = ENV["MEMBERS"].split(",")
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
         
  validates_presence_of :email, :role, :first_name, :last_name
  
  # Added to allow devise to send emails using Delayed Job
  handle_asynchronously :send_on_create_confirmation_instructions
  handle_asynchronously :send_reset_password_instructions
  handle_asynchronously :send_confirmation_instructions
  
  after_save ThinkingSphinx::RealTime.callback_for(:user)

  has_many :features, :foreign_key=>:assigned_to
  has_many :tasks, :foreign_key=>:assigned_to
  
    
  def super_user?
    role == "Super User"
  end
  
  def team_member?
    role == "Team Member"
  end
  
  
  def full_name
    first_name + " " + last_name
  end
end
