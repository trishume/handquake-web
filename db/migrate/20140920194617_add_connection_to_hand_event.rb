class AddConnectionToHandEvent < ActiveRecord::Migration
  def change
    add_reference :hand_events, :connection, index: true
  end
end
