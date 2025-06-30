class RemoveUniqueIndexFromSubdomains < ActiveRecord::Migration[8.0]
  def change
    # Removes the unique index on the 'subdomain' column.
    remove_index :subdomains, :subdomain, unique: true

    # Adds a non-unique index back. This is good for query performance.
    add_index :subdomains, :subdomain
  end
end
