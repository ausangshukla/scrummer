class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :features
  has_many :tasks, :through => :features

  validates_presence_of :iteration

  after_initialize :init_defaults
  def init_defaults
    self.planned_hours  ||= 0
    self.actual_hours   ||= 0
  end

  def days
    (end_date - start_date).to_i 
  end

  def man_days
    days * self.project.project_user_mappings.team_members.count
  end
  
  def remaining_days

    planned_days = days

    cum_hours = {}
    (0..planned_days).each do |day|
      cum_hours[day] ||= 0
    end

    # get the cumulative hours logged per day
    self.tasks.each do |t|
      date = t.updated_at.to_date
      day = (date - start_date).to_i
      cum_hours[day] ||= 0
      cum_hours[day] += t.actual_hours
    end

    total_planned_hours = planned_days * Project::HOURS_PER_DAY

    # Get the remaining hours after every days work
    (0..planned_days).each do |day|
      todays_hours = cum_hours[day]
      cum_hours[day] = ((total_planned_hours - cum_hours[day])/Project::HOURS_PER_DAY).to_i
      total_planned_hours -= todays_hours
    end

    cum_hours
  end
end
