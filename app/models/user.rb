class User
  include Mongoid::Document

  field :user_id, type: Integer
  field :points, type: Integer
  field :name, type: String

  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :points

  index :points => 1
  index :user_id => 1

  after_initialize :init

  def init
  	self.points||=0
  end

  def self.append_points(user_id, points)
    user = User.find_or_create_by(user_id: user_id)
    user.inc(points: points)
  end
end
