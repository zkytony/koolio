class AddSubdomainColumnToTables < ActiveRecord::Migration
  def up
    add_column :cards, :subdomain, :string, default: "www"
    add_column :decks, :subdomain, :string, default: "www"
    add_column :users, :register_subdomain, :string, default: "www"
  end

  def down
    remove_column :decks, :subdomain
    remove_column :cards, :subdomain
    remove_column :users, :register_subdomain
  end
end
