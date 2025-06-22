class CreateEnumerationScanResults < ActiveRecord::Migration[8.0]
  def change
    create_table :enumeration_scan_results do |t|
      t.string :name
      t.text :webserver
      t.jsonb :technologies
      t.jsonb :ip
      t.text :title
      t.integer :status_code
      t.integer :port
      t.text :asn
      t.integer :content_length
      t.jsonb :cname
      t.text :url
      t.references :enumeration_scan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
