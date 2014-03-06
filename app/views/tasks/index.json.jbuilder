json.array!(@tasks) do |task|
  json.extract! task, :id, :summary, :details, :notes, :status, :task_type, :assigned_to, :project_id, :feature_id, :planned_hours, :actual_hours, :remaining_hours
  json.url task_url(task, format: :json)
end
