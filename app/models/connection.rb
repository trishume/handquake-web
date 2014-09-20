class Connection < ActiveRecord::Base
  belongs_to :u1, class_name: "User"
  belongs_to :u2, class_name: "User"
  has_many :hand_events

  def find_other(id)
    return u1 if u1.id != id
    u2
  end
end
