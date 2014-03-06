class AddSprintIdToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :sprint_id, :integer
    add_index :features, :sprint_id
  end
end
