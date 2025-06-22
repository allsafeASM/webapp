class CreateSubdomains < ActiveRecord::Migration[8.0]
  def change
    create_table :subdomains do |t|
      t.string :subdomain
      t.datetime :first_seen
      t.datetime :last_seen
      t.string :dns_status
      t.boolean :is_web
      t.references :domain, null: false, foreign_key: true

      t.timestamps
    end
    add_index :subdomains, :subdomain, unique: true
  end
end
