class CreateDistances < ActiveRecord::Migration
  def change
    create_table :distances do |t|
      t.string :origin, null: false
      t.string :destination, null: false
      t.float :distance
      t.timestamps
    end
    
    add_index :distances, [:origin, :destination], unique: true
  end
end
