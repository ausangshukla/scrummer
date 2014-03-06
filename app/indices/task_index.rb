ThinkingSphinx::Index.define :task, :with => :real_time do
  
  # fields
  indexes summary
  indexes details
  indexes status
  indexes task_type
  indexes notes
  

  set_property :enable_star => 1
  set_property :min_infix_len => 2
  set_property :dict => :keywords
  
  set_property :field_weights => {
    :summary  => 10,
    :details  => 6,
    :status  => 8,
    :task_type  => 8,
    :notes => 4
  }
  
end
