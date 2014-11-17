class LeaderboardsController < ApplicationController
  before_action :query_options

  def show
    @lb = Boards.default_leaderboard
    @entries = @lb.leaders(@page, page_size: @limit)
    respond_to do |format|
      format.html do
        @page_array = Kaminari.paginate_array(@entries, total_count: @lb.total_members).page(@page).per(@limit)
      end
      format.json do
        render json: @entries
      end
    end 
  end

  private

  def query_options
    @limit = [params.fetch(:limit, 10).to_i, 100].min
    @page = params.fetch(:page, 1).to_i
  end
end
