class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.references :u1, index: true
      t.references :u2, index: true

      t.timestamps
    end
  end
end
