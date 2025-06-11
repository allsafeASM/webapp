class CreateIdentities < ActiveRecord::Migration[7.1]
  def change
    create_table :identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name
      t.string :email
      t.string :image
      t.string :token
      t.string :refresh_token
      t.datetime :expires_at

      t.timestamps
    end
    
    add_index :identities, [:provider, :uid], unique: true
  end
end
