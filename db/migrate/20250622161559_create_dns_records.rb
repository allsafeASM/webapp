class CreateDnsRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :dns_records do |t|
      t.text :cname_record
      t.text :mx_record
      t.text :ns_record
      t.references :subdomain, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
