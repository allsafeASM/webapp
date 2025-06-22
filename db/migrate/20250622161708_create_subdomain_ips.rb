class CreateSubdomainIps < ActiveRecord::Migration[8.0]
  def change
    create_table :subdomain_ips do |t|
      t.datetime :resolved_on
      t.references :subdomain, null: false, foreign_key: true
      t.references :ip_address, null: false, foreign_key: true

      t.timestamps
    end
    add_index :subdomain_ips, [:subdomain_id, :ip_address_id], unique: true, name: 'index_subdomain_ips_on_subdomain_and_ip'
  end
end
