class AddPushedToHandEvent < ActiveRecord::Migration
  def change
    add_column :hand_events, :pushed, :bool
  end
end
