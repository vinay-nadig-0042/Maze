class Box < ActiveRecord::Base
  has_one :left_adjacent_box, class_name: 'Box', foreign_key: :left_adjacent_box_id
  has_one :right_adjacent_box, class_name: 'Box', foreign_key: :right_adjacent_box_id
  has_one :top_adjacent_box, class_name: 'Box', foreign_key: :top_adjacent_box_id
  has_one :bottom_adjacent_box, class_name: 'Box', foreign_key: :bottom_adjacent_box_id

  def next_traversable_boxes
    boxes = []
    boxes.push(self.left_adjacent_box) if self.left == 0 && self.left_adjacent_box.try(:right) == 0 && !self.left_adjacent_box.traversed
    boxes.push(self.right_adjacent_box) if self.right == 0 && self.right_adjacent_box.try(:left) == 0 && !self.right_adjacent_box.traversed
    boxes.push(self.top_adjacent_box) if self.top == 0 && self.top_adjacent_box.try(:bottom) == 0 && !self.top_adjacent_box.traversed
    boxes.push(self.bottom_adjacent_box) if self.bottom == 0 && self.bottom_adjacent_box.try(:top) == 0 && !self.bottom_adjacent_box.traversed
    boxes
  end

  def next_traversal
    return self.left_adjacent_box if self.next_traversable_boxes.include? self.left_adjacent_box
    return self.bottom_adjacent_box if self.next_traversable_boxes.include? self.bottom_adjacent_box
    return self.right_adjacent_box if self.next_traversable_boxes.include? self.right_adjacent_box
    return self.top_adjacent_box if self.next_traversable_boxes.include? self.top_adjacent_box
  end
end