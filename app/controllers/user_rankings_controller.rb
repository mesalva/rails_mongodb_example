class UserRankingsController < ApplicationController
  before_action :set_user_ranking, only: [:show, :edit, :update, :destroy]

  # GET /user_rankings
  # GET /user_rankings.json
  def index
    @user_rankings = UserRanking.all
  end

  # GET /user_rankings/1
  # GET /user_rankings/1.json
  def show
  end

  # GET /user_rankings/new
  def new
    @user_ranking = UserRanking.new
  end

  # GET /user_rankings/1/edit
  def edit
  end

  def path_index
    limit = params[:limit]||RANKING_PAGE_LIMIT
    offset = params[:offset]||0
    @user_rankings = UserRanking.find_by_path(request.path, limit, offset)
  end

  def render_result
    if @errors
      render json: @errors, status: :unprocessable_entity
    else
      head :created
    end
    
  end

  def path_create
    create_params= user_ranking_params.merge(path: request.path)
    handle_queue(create_params)

    render_result
  end

  def handle_queue(create_params)
    @errors = UserRanking.validate(create_params)
    unless (Rails.env.test?)
      MESSAGING_SERVICE.publish(create_params)
    else
      UserRanking.create_or_append(create_params)
    end
    
  end

  # POST /user_rankings
  # POST /user_rankings.json
  def create
    create_params= user_ranking_params.merge(user_ranking_params)
    handle_queue(create_params)

    render_result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_ranking
      @user_ranking = UserRanking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_ranking_params
      params.require(:user_ranking).permit(:user_id, :path, :points)
    end
end
