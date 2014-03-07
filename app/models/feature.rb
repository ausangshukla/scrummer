class Feature < ActiveRecord::Base
  PRIORITIES = ENV["FEATURE_PRIORITIES"].split(",")
  CLASSIFICATIONS = ENV["FEATURE_CLASSIFICATIONS"].split(",")
  STATUSES = ENV["FEATURE_STATUSES"].split(",")
    
  belongs_to :project
  belongs_to :sprint
  belongs_to :user, :foreign_key=>:assigned_to
  has_many :tasks
  
  validates_presence_of :summary
  
  after_save ThinkingSphinx::RealTime.callback_for(:feature)
  after_initialize :init_defaults
     
  def init_defaults
    self.priority       ||= PRIORITIES[0]
    self.status         ||= STATUSES[0]
    self.classification ||= CLASSIFICATIONS[0]
    self.planned_hours  ||= 0
    self.actual_hours   ||= 0
  end
  
 after_save     :compute_hours
 before_destroy :compute_hours

 def compute_hours
   self.sprint.planned_hours = self.sprint.features.sum(:planned_hours)
   self.sprint.actual_hours  = self.sprint.features.sum(:actual_hours)
   self.sprint.save
 end
  
end
