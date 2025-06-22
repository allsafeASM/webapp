class CreateIpAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :ip_addresses do |t|
      t.string :ip_address
      t.string :asn
      t.string :org

      t.timestamps
    end
    add_index :ip_addresses, :ip_address, unique: true
  end
end
