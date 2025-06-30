class CreateWebserversTechnologies < ActiveRecord::Migration[8.0]
  def change
    create_table :webservers_technologies do |t|
      t.references :webserver, null: false, foreign_key: true
      t.references :technology, null: false, foreign_key: true

      t.timestamps
    end
    add_index :webservers_technologies, [ :webserver_id, :technology_id ], unique: true, name: 'index_webservers_technologies_on_webserver_and_tech'
  end
end
