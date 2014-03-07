class AddHoursToFeature < ActiveRecord::Migration
  def change
    add_column :features, :planned_hours, :float
    add_column :features, :actual_hours, :float
  end
end
