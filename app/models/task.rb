class Task < ActiveRecord::Base
  
  STATUSES  = ENV["TASK_STATUSES"].split(",")
  TYPES     = ENV["TASK_TYPES"].split(",")
    
  belongs_to :project
  belongs_to :feature
  belongs_to :user, :foreign_key=>:assigned_to
  
  validates_presence_of :summary, :status, :task_type

  after_save ThinkingSphinx::RealTime.callback_for(:task)
  after_initialize :init_defaults
  def init_defaults
    self.status         ||= STATUSES[0]
    self.task_type      ||= TYPES[0]
  end
end
