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
    self.actual_hours   ||= 0
  end
  
  after_save     :compute_hours
  before_destroy :compute_hours

  def compute_hours
    self.feature.planned_hours = self.feature.tasks.sum(:planned_hours)
    self.feature.actual_hours  = self.feature.tasks.sum(:actual_hours)
    self.feature.save
  end
  
  
  
end
