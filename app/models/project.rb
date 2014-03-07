class Project < ActiveRecord::Base
  RAG_STATUSES = ["Red", "Amber", "Green"]
  validates_presence_of :name
  
  has_many :features, :dependent=>:delete_all
  has_many :tasks, :dependent=>:delete_all
  has_many :sprints, :dependent=>:delete_all
  has_many :project_user_mappings, :dependent=>:delete_all
  
  has_many :users, :through=>:project_user_mappings
  
  after_save ThinkingSphinx::RealTime.callback_for(:project)
  
end
