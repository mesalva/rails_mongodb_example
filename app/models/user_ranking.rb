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

  def ranking_paths
    @@structure||=Path.first.structure
  end

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

  def self.append_points(params,user)
  	points = params[:points].to_i
    path = params[:path]
    user_id = params[:user_id]
    collection_name = get_collection_name(path)
    #p "===============> collection name: #{collection_name}"
  	user_ranking = UserRanking.with(collection: collection_name).find_or_initialize_by(user_id: params[:user_id], path: path)
    
    user_ranking.points=points
    
  	user_ranking.with(collection: collection_name).save!
    
    if (user_ranking.was_a_new_record)
      path_parts = path.split('/')
      length = path_parts.length
      resource = path_parts[length-2]
      user.append_resource(resource)
    end
    


    user_ranking
  end

  def self.verify_children_status(user_ranking)

    children_paths = user_ranking.children_paths
    #p "=====> path: #{user_ranking.path}"
    return unless children_paths
    #p "=========> children paths: #{children_paths} size: #{children_paths.length} all: #{UserRanking.all.entries}"

    children = UserRanking.with(collection: get_collection_name(user_ranking.path))
      .where(user_id: user_ranking.user_id, path: {"$in": children_paths})
    
    #p "children: #{children.first.to_json}"

    count = children.size

    #p "====> count: #{count} children: #{children_paths.length}"
    #User.append_points(user_ranking.user_id, user_ranking.points, [user_ranking.path]) if count == children_paths.length
  end

  def children_paths
    
    level = ranking_paths
    
    path.split('/').each do |part|
    
      level = level[part.to_s] rescue next
    end
    
    if level.is_a?(Hash)
      children_paths = []
      level.each do |k,v|
        children_paths << v.map {|entry| "#{path}/#{k}/#{entry}"}
      end
    
      return children_paths.flatten
    end
    nil
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
    user = User.find_or_create_by(user_id: user_id)
  	path_parts = path.split('/')
  	position = path_parts.length
  	return if position <= 2
    first_user_ranking=nil
    loop do
      break if position < 1
      path = path_parts.slice(0,position).map(&:inspect).join('/').gsub(/\\/,'').gsub(/"/,'')
      user_ranking = UserRanking.append_points(params.merge(path: path),user)
      first_user_ranking||=user_ranking
      #p "=====> path: #{path}"
      position-=2
    end 


    score_paths = [path_parts[(path_parts.length)-2]]
    #verify_children_status(user_ranking)
    user.append_points(points)

    first_user_ranking
  end



end
