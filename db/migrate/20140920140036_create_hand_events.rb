class CreateHandEvents < ActiveRecord::Migration
  def change
    create_table :hand_events do |t|
      t.references :user, index: true
      t.float :latitude
      t.float :longitude
      t.datetime :time
      t.float :dir

      t.timestamps
    end
  end
end
