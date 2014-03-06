class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :features
  
  validates_presence_of :iteration
end
