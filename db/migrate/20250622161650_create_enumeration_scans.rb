class CreateEnumerationScans < ActiveRecord::Migration[8.0]
  def change
    create_table :enumeration_scans do |t|
      t.string :name
      t.datetime :completed_at
      t.string :status
      t.text :failure_reason
      t.integer :total_assets
      t.string :scan_time_elapsed
      t.references :domain, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
