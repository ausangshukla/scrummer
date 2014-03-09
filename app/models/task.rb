class Task < ActiveRecord::Base
  attr_accessor :tasks_for
  
  STATUSES          = ENV["TASK_STATUSES"].split(",")
  DEVELOPMENT_TASKS = ENV["DEVELOPMENT_TASKS"].split(",")
  MANAGEMENT_TASKS  = ENV["MANAGEMENT_TASKS"].split(",")    
  TYPES             = DEVELOPMENT_TASKS + MANAGEMENT_TASKS 
    
    
  TASK_DONE         = ENV["TASK_DONE"].split(",")
  TASK_WIP          = ENV["TASK_WIP"].split(",")
  TASK_NOT_STARTED  = ENV["TASK_NOT_STARTED"].split(",")
  TASK_OTHER        = ENV["TASK_OTHER"].split(",")
    
  TASK_INPROGRESS   = ENV["TASK_INPROGRESS"]
  TASK_COMPLETED    = ENV["TASK_COMPLETED"]
    
  belongs_to :project
  belongs_to :feature
  belongs_to :user, :foreign_key=>:assigned_to
  
  validates_presence_of :summary, :status, :task_type
  
  scope :development_tasks, -> {
    where(task_type: DEVELOPMENT_TASKS)
  }
  scope :management_tasks, -> {
    where(task_type: MANAGEMENT_TASKS)
  }
  
  scope :completed, -> {
    where(status:TASK_DONE)
  }
  scope :wip, -> {
    where(status:TASK_WIP)
  }
  
  scope :not_started, -> {
    where(status:TASK_NOT_STARTED)
  }
  
  scope :other, -> {
    where(status:TASK_OTHER)
  }

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
    if self.feature
      self.feature.planned_hours = self.feature.tasks.sum(:planned_hours) 
      self.feature.actual_hours  = self.feature.tasks.sum(:actual_hours)
      self.feature.save
    end
  end
  
  before_save :check_started
  def check_started
    if self.status == "In Progress" && self.status != self.status_was
      self.started_on = Time.now
    end 
    if self.status == "Done" && self.status != self.status_was && self.started_on
      # http://stackoverflow.com/questions/11680519/round-to-closest-integer-or-closest-5-in-ruby
      x = ((Time.now - self.started_on) / 60 / 60) 
      self.actual_hours = (x * 2).round / 2.0
    end
  end
  
end
