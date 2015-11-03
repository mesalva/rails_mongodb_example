# Model for any relation between a user and a ranking
class UserRanking
  include Mongoid::Document
  field :user_id, type: Integer
  field :path, type: String
  field :points, type: Integer

  validates_uniqueness_of :path, :scope => :user_id
  validates_presence_of :user_id, :points

  index :path => 1
  index :points => -1

  validate :validate_path

  attr_accessor :was_a_new_record

  before_save :check_new_record

  def check_new_record
    @was_a_new_record = new_record?
    return true
  end

  def validate_path
    errors.add(:path, "Invalid Path: #{self.path}") unless self.path.split('/').length%2==0
  end

  def self.get_collection_name(path)
    path.split('/')[0..1].map(&:inspect).join('_').gsub(/\\/,'').gsub(/"/,'')
  end

  def self.append_points(params)
  	points = params[:points].to_i
    path = params[:path]
    collection_name = get_collection_name(path)
    #p "===============> collection name: #{collection_name}"
  	user_ranking = UserRanking.with(collection: collection_name).where(user_id: params[:user_id], path: path).first
    unless user_ranking
      user_ranking = UserRanking.new(user_id: params[:user_id], path: path, points: points)
    else
      user_ranking.points+=points
    end
  	user_ranking.with(collection: collection_name).save!
    user_ranking
  end

  def self.find_in_path(options)
    #p "===============> collection name: #{get_collection_name(options[:path])}"
    self.with(collection: get_collection_name(options[:path])).find_by(options)
  end

  def self.find_by_path(path, limit, offset)
    path.slice!(0) if path.starts_with?("/")
    collection_name = get_collection_name(path)
    #p "===============> collection name: #{collection_name}"
    UserRanking.with(collection: collection_name).all(path: path).order_by(points: :desc).limit(limit).offset(offset)
  end

  def self.validate(params)
    errors = {}
    if (params.nil? || params.blank?)
      errors[:params] = "Params user_id, points and path can't be blank"
    else
      errors[:user_id] = "User id can't be blank" unless params[:user_id]
      errors[:path] = "Path can't be blank" unless params[:path]
      errors[:points] = "Points can't be blank" unless params[:points]
    end
    raise ValidationException.new(errors) unless errors.empty?
  end

  def self.create_or_append(params)
    validate(params)
  	path = params[:path]
    path.slice!(0) if path.starts_with?("/")
  	points = params[:points].to_i
  	user_id = params[:user_id].to_i
  	path_parts = path.split('/')
  	length = path_parts.length
  	return if length <= 2

  	pairs = length/2 - 1

  	initial = 0
    score_paths = [path_parts[length-2]]
  	pairs.times do |position|
  		parent_path = path_parts.slice(0,initial+=2)
  			.map(&:inspect).join('/').gsub(/\\/,'').gsub(/"/,'')
      #score_paths << parent_path.split('/').first
  		UserRanking.append_points(user_id: params[:user_id], path: parent_path, points: points)
  	end

  	user_ranking = UserRanking.append_points(params)

    User.append_points(user_id, points, user_ranking.was_a_new_record ? score_paths : [])

    user_ranking
  end



end
