# Model for any relation between a user and a ranking
class UserRanking
  include Mongoid::Document
  field :user_id, type: Integer
  field :path, type: String
  field :points, type: Integer

  field :done, type: Boolean

  validates_uniqueness_of :path, :scope => :user_id
  validates_presence_of :user_id, :points

  index :path => 1
  index :points => -1

  validate :validate_path

  attr_accessor :was_a_new_record

  before_save :check_new_record

  def ranking_paths
    @@structure||=Path.first.structure
  rescue
    {}
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

  def self.append_points(params,user,first)
  	points = params[:points].to_i
    path = params[:path]
    
    user_id = params[:user_id]
    collection_name = get_collection_name(path)
    
  	user_ranking = UserRanking.with(collection: collection_name).find_or_initialize_by(user_id: params[:user_id], path: path)
    
    raise ExistentRankingException.new("Path #{path} for user #{user_id} already exists") if (first && user_ranking.id)
    
    user_ranking.points+=points
    
  	user_ranking.with(collection: collection_name).save!
    
    if (first)
      user_ranking.verify_children_status(path,user,user_ranking)
    else
      user_ranking.verify_children_status(path,user,user_ranking) unless user_ranking.done
    end
    
    user_ranking
  end

  def verify_children_status(path,user,user_ranking)

    path_parts = path.split('/')
    length = path_parts.length
    resource = path_parts[length-2]
    

    children_paths = self.children_paths
    
    mark_as_done = true
    if children_paths
    
      count = UserRanking.with(collection: UserRanking.get_collection_name(self.path))
        .where(user_id: self.user_id, path: {"$in": children_paths}).count
      mark_as_done = (count == children_paths.length)
    
    end
    
    if (mark_as_done)
      user.append_resource(resource) if mark_as_done
      user_ranking.done = true
      user_ranking.save!
    end
    
    
  end

  def children_paths
    
    level = ranking_paths
    return nil unless level
    
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
      user_ranking = UserRanking.append_points(params.merge(path: path),user,(first_user_ranking.nil?))
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
