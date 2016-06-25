class AddSubdomainToCategory < ActiveRecord::Migration
  def up
    add_column :categories, :subdomain, :string, default: "www"
  end

  def down
    remove_column :categories, :subdomain
  end
end
