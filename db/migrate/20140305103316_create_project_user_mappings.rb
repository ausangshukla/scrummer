class CreateProjectUserMappings < ActiveRecord::Migration
  def change
    create_table :project_user_mappings do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :role, limit: 20

      t.timestamps
    end
    add_index :project_user_mappings, :user_id
    add_index :project_user_mappings, :project_id
  end
end
