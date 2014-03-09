class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :features
  has_many :tasks, :through => :features

  validates_presence_of :iteration
  
  scope :till_date, -> {
    where("start_date <= ?", Date.today)
  }

  after_initialize :init_defaults
  def init_defaults
    self.planned_hours  ||= 0
    self.actual_hours   ||= 0
  end
  
  def developers
    self.project.project_user_mappings.team_members
  end

  def days
    (end_date - start_date).to_i 
  end

  def man_days
    days * developers.count
  end
  
  def available_hours
    man_days * Project::HOURS_PER_DAY
  end
  
  def overflow?
     available_hours < planned_hours
  end
  
  def remaining_days
    
    
    planned_days = Date.today < end_date ? (Date.today - start_date).to_i : (end_date - start_date).to_i

    cum_hours = {}
    (0..planned_days).each do |day|
      cum_hours[day] ||= 0
    end

    # get the cumulative hours logged per day till date by developers
    self.tasks.development_tasks.each do |t|
      date = t.updated_at.to_date
      if date <= Date.today
        day = (date - start_date).to_i
        cum_hours[day] ||= 0
        cum_hours[day] += t.actual_hours
      end
    end

    total_planned_hours = planned_days * developers.count * Project::HOURS_PER_DAY

    cum_days = {}
    # Get the remaining hours after every days work
    dev_count = developers.count
    (0..planned_days).each do |day|
      todays_hours = cum_hours[day]
      cum_days[day] = ((total_planned_hours - cum_hours[day])/(Project::HOURS_PER_DAY * dev_count)).to_i
      total_planned_hours -= todays_hours
    end

    cum_days
  end
end
