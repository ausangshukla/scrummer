class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.integer :iteration
      t.date :start_date
      t.date :end_date
      t.text :notes
      t.string :rag_status, limit:10
      t.integer :project_id

      t.timestamps
    end
    add_index :sprints, :project_id
  end
end
