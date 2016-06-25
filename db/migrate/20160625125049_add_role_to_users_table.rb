class AddRoleToUsersTable < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :role
    end
  end

  def self.down
    remove_column :users, :role
  end
end
