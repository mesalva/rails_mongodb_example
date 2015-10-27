class UserRanking
  include Mongoid::Document
  field :user_id, type: Integer
  field :path, type: String
  field :points, type: Integer

  validates_uniqueness_of :path, :scope => :user_id
  validates_presence_of :user_id, :points

  def self.create_or_append(params)
  	user_ranking = UserRanking.find_or_create_by(user_id: params[:user_id], path: params[:path])
  	user_ranking.points += params[:points].to_i
  	user_ranking.save!
  	user_ranking
  end



end
