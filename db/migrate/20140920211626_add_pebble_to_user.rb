class AddPebbleToUser < ActiveRecord::Migration
  def change
    add_column :users, :pebble, :string
  end
end
