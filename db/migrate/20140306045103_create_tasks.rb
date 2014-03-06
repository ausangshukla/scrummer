class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :summary
      t.text :details
      t.text :notes
      t.string :status, limit:10
      t.string :task_type, limit:10
      t.integer :assigned_to
      t.integer :project_id
      t.integer :feature_id
      t.float :planned_hours
      t.float :actual_hours
      t.float :remaining_hours

      t.timestamps
    end
    add_index :tasks, :assigned_to
    add_index :tasks, :project_id
    add_index :tasks, :feature_id
  end
end
