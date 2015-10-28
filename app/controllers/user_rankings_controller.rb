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
    limit = params[:limit]||10
    offset = params[:offset]||0
    @user_rankings = UserRanking.find_by_path(request.path, limit, offset)
  end

  def render_result
    respond_to do |format|
      if @user_ranking.save
        format.html { redirect_to @user_ranking, notice: 'User ranking was successfully created.' }
        format.json { render :show, status: :created, location: @user_ranking }
      else
        format.html { render :new }
        format.json { render json: @user_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  def path_create
    @user_ranking = UserRanking.create_or_append(user_ranking_params.merge(path: request.path))

    render_result
  end

  # POST /user_rankings
  # POST /user_rankings.json
  def create
    @user_ranking = UserRanking.create_or_append(user_ranking_params)

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
