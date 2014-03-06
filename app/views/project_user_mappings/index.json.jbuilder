json.array!(@project_user_mappings) do |project_user_mapping|
  json.extract! project_user_mapping, :id, :user_id, :project_id, :role
  json.url project_user_mapping_url(project_user_mapping, format: :json)
end
