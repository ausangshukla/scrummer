# Spihnx indexes
ThinkingSphinx::Index.define :project, :with => :real_time do
  
  # fields
  indexes name
  indexes status

  # attributes
  has status, :type=>:string, :as => :status_sort
  has created_at, :type=>:timestamp, :as => :created_at_sort
  

  set_property :enable_star => 1
  set_property :min_infix_len => 2
  set_property :dict => :keywords

  set_property :field_weights => {
    :name  => 10,
    :status  => 6
  }

end