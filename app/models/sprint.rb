class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :features
  
  validates_presence_of :iteration
  
  after_initialize :init_defaults
  def init_defaults
    self.planned_hours  ||= 0
    self.actual_hours   ||= 0
  end
end
