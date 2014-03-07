class Task < ActiveRecord::Base
  attr_accessor :tasks_for
  
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
    self.planned_hours  ||= 4
  end
  
  # before_save :compute_hours
  def compute_hours
    if(self.planned_hours > 0 && self.actual_hours > 0)
      self.remaining_hours = self.planned_hours - self.actual_hours
    end  
  end
  
end
