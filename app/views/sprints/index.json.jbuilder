json.array!(@sprints) do |sprint|
  json.extract! sprint, :id, :iteration, :start_date, :end_date, :notes, :rag_status, :project_id
  json.url sprint_url(sprint, format: :json)
end
