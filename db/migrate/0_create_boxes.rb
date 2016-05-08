class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.integer :left
      t.integer :right
      t.integer :top
      t.integer :bottom
      t.boolean :start
      t.boolean :end
      t.boolean :traversed, default: false
      t.boolean :turning_point, default: false
      t.integer :left_adjacent_box_id
      t.integer :right_adjacent_box_id
      t.integer :top_adjacent_box_id
      t.integer :bottom_adjacent_box_id
    end
  end
end