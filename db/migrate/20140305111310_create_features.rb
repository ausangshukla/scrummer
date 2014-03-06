class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :summary
      t.text :details
      t.text :acceptance_criteria
      t.integer :project_id
      t.string :status, limit:30
      t.string :priority, limit:10
      t.float :points
      t.string :classification, limit:30
      t.integer :assigned_to

      t.timestamps
    end
    add_index :features, :project_id
    add_index :features, :assigned_to
  end
end
