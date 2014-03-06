json.array!(@features) do |feature|
  json.extract! feature, :id, :summary, :details, :acceptance_criteria, :project_id, :status, :priority, :points, :classification, :assigned_to
  json.url feature_url(feature, format: :json)
end
