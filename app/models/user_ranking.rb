class UserRanking
  include Mongoid::Document
  field :user_id, type: Integer
  field :path, type: String
  field :points, type: Integer

  validates_uniqueness_of :path, :scope => :user_id
  validates_presence_of :user_id, :points

  index :path => 1
  index :points => 1


  def self.append_points(params)
  	points = params[:points].to_i
  	user_ranking = UserRanking.find_or_create_by(user_id: params[:user_id], path: params[:path])
  	user_ranking.inc(points: points)
  	user_ranking
  end

  def self.find_by_path(path, limit, offset)
    UserRanking.all(path: path).order_by(points: :desc).limit(limit).offset(offset)
  end

  def self.create_or_append(params)
  	path = params[:path]
  	points = params[:points].to_i
  	user_id = params[:user_id].to_i
  	path_parts = path.split('/')
  	length = path_parts.length
  	return if length <= 2

  	pairs = length/2 - 1

  	initial = 0
  	pairs.times do |position|
  		parent_path = path_parts.slice(0,initial+=2)
  			.map(&:inspect).join('/').gsub(/\\/,'').gsub(/"/,'')
  		UserRanking.append_points(user_id: params[:user_id], path: parent_path, points: points)
  	end

  	User.append_points(user_id, points)

  	UserRanking.append_points(params)
  end



end
