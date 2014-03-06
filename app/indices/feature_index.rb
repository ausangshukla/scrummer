ThinkingSphinx::Index.define :feature, :with => :real_time do
  
  # fields
  indexes summary
  indexes details
  indexes status
  indexes priority
  indexes classification
  indexes points
  indexes acceptance_criteria
  

  set_property :enable_star => 1
  set_property :min_infix_len => 2
  set_property :dict => :keywords
  
  set_property :field_weights => {
    :summary  => 10,
    :details  => 6,
    :status  => 8,
    :priority  => 8,
    :classification  => 8,
    :points  => 6,
    :acceptance_criteria => 4
  }
  
end
