class AddTypeToFeature < ActiveRecord::Migration
  def change
    add_column :features, :feature_type, :string, limit:20
  end
end
