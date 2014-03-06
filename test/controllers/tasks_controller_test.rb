require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { actual_hours: @task.actual_hours, assigned_to: @task.assigned_to, details: @task.details, feature_id: @task.feature_id, notes: @task.notes, planned_hours: @task.planned_hours, project_id: @task.project_id, remaining_hours: @task.remaining_hours, status: @task.status, summary: @task.summary, task_type: @task.task_type }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { actual_hours: @task.actual_hours, assigned_to: @task.assigned_to, details: @task.details, feature_id: @task.feature_id, notes: @task.notes, planned_hours: @task.planned_hours, project_id: @task.project_id, remaining_hours: @task.remaining_hours, status: @task.status, summary: @task.summary, task_type: @task.task_type }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
