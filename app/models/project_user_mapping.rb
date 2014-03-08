class ProjectUserMapping < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :role, :user_id, :project_id
  
  scope :team_members, -> {
    where(role:"Team Member")
  }
end
