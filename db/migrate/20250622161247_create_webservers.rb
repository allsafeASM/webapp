class CreateWebservers < ActiveRecord::Migration[8.0]
  def change
    create_table :webservers do |t|
      t.integer :port_number
      t.string :name
      t.text :title
      t.integer :status_code
      t.bigint :content_length
      t.text :url
      t.references :subdomain, null: false, foreign_key: true

      t.timestamps
    end
    add_index :webservers, [:subdomain_id, :port_number], unique: true
  end
end
