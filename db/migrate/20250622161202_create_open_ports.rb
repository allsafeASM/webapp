class CreateOpenPorts < ActiveRecord::Migration[8.0]
  def change
    create_table :open_ports do |t|
      t.integer :port_number
      t.boolean :is_web
      t.references :ip_address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
