class Feature < ActiveRecord::Base
  PRIORITIES = ENV["FEATURE_PRIORITIES"].split(",")
  CLASSIFICATIONS = ENV["FEATURE_CLASSIFICATIONS"].split(",")
  STATUSES = ENV["FEATURE_STATUSES"].split(",")
  TYPES = ENV["FEATURE_TYPES"].split(",")
  TYPE_POINTS = ENV["FEATURE_TYPES_POINTS"].split(",")
    
  FEATURE_DONE         = ENV["FEATURE_DONE"].split(",")
  FEATURE_WIP          = ENV["FEATURE_WIP"].split(",")
  FEATURE_NOT_STARTED  = ENV["FEATURE_NOT_STARTED"].split(",")
  FEATURE_OTHER        = ENV["FEATURE_OTHER"].split(",")

  belongs_to :project
  belongs_to :sprint
  belongs_to :user, :foreign_key=>:assigned_to
  has_many :tasks

  validates_presence_of :summary
  
  scope :completed, -> {
    where(status:FEATURE_DONE)
  }
  scope :wip, -> {
    where(status:FEATURE_WIP)
  }
  
  scope :not_started, -> {
    where(status:FEATURE_NOT_STARTED)
  }
  
  scope :other, -> {
    where(status:FEATURE_OTHER)
  }

  after_save ThinkingSphinx::RealTime.callback_for(:feature)
  after_initialize :init_defaults
 
  def init_defaults
    self.priority       ||= PRIORITIES[0]
    self.feature_type   ||= TYPES[-1]
    self.points         ||= TYPE_POINTS[-1]
    self.status         ||= STATUSES[0]
    self.classification ||= CLASSIFICATIONS[0]
    self.planned_hours  ||= 0
    self.actual_hours   ||= 0
  end

  after_save     :compute_hours
  before_destroy :compute_hours

  def compute_hours
    if self.sprint
      self.sprint.planned_hours = self.sprint.features.sum(:planned_hours)
      self.sprint.actual_hours  = self.sprint.features.sum(:actual_hours)
      self.sprint.save
    end
  end
  
  def overflow?
    actual_hours > planned_hours
  end

end

