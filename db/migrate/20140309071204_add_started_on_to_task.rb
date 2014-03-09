class AddStartedOnToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :started_on, :datetime
  end
end
