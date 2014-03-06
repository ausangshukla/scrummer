class Project < ActiveRecord::Base
  RAG_STATUSES = ["Red", "Amber", "Green"]
  validates_presence_of :name
  
  has_many :features
  has_many :tasks
  has_many :sprints
  has_many :project_user_mappings
  has_many :users, :through=>:project_user_mappings
  
  after_save ThinkingSphinx::RealTime.callback_for(:project)
  
end
