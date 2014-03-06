require 'test_helper'

class ProjectUserMappingsControllerTest < ActionController::TestCase
  setup do
    @project_user_mapping = project_user_mappings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_user_mappings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_user_mapping" do
    assert_difference('ProjectUserMapping.count') do
      post :create, project_user_mapping: { project_id: @project_user_mapping.project_id, role: @project_user_mapping.role, user_id: @project_user_mapping.user_id }
    end

    assert_redirected_to project_user_mapping_path(assigns(:project_user_mapping))
  end

  test "should show project_user_mapping" do
    get :show, id: @project_user_mapping
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_user_mapping
    assert_response :success
  end

  test "should update project_user_mapping" do
    patch :update, id: @project_user_mapping, project_user_mapping: { project_id: @project_user_mapping.project_id, role: @project_user_mapping.role, user_id: @project_user_mapping.user_id }
    assert_redirected_to project_user_mapping_path(assigns(:project_user_mapping))
  end

  test "should destroy project_user_mapping" do
    assert_difference('ProjectUserMapping.count', -1) do
      delete :destroy, id: @project_user_mapping
    end

    assert_redirected_to project_user_mappings_path
  end
end
