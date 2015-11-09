class User
  include Mongoid::Document

  field :user_id, type: Integer
  field :points, type: Integer
  field :name, type: String

  field :score, type: Hash  

  field :resources, type: Hash

  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :points

  index :points => -1
  index :user_id => 1

  after_initialize :init

  def init
  	self.points||=0
  end

  def append_points(points)
    self.points+=points
    self.save!
  end

  def append_resource(resource)
    
    self.score||= {}
    
    key = resource.to_sym
    value = self.score[key]
    self.score[key] =  value ? (value + 1) : 1
    
    self.save!
  end
end
