class RemoveUniqueIndexFromDomains < ActiveRecord::Migration[8.0]
  def change
    # Removes the unique index on the 'domain' column.
    remove_index :domains, :domain, unique: true

    # Adds a non-unique index back. This is good for query performance.
    add_index :domains, :domain
  end
end