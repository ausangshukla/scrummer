class AddHoursToSprint < ActiveRecord::Migration
  def change
    add_column :sprints, :planned_hours, :float
    add_column :sprints, :actual_hours, :float
  end
end
