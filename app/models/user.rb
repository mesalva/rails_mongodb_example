class User
  include Mongoid::Document

  field :user_id, type: Integer
  field :points, type: Integer
  field :name, type: String

  field :score, type: Hash  

  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :points

  index :points => -1
  index :user_id => 1

  after_initialize :init

  def init
  	self.points||=0
  end

  def self.append_points(user_id, points, resource_types)
    user = User.find_or_create_by(user_id: user_id)
    user.points+=points
    
    score = user.score || {}
    resource_types.each do |resource_type|
      key = resource_type.to_sym
      value = score[key]
      score[key] =  value ? (value + 1) : 1
    end

    user.score = score
    user.save!
  end
end
