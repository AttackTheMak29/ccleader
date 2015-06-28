class EntriesController < ApplicationController
  
  after_action :set_access_control_headers
  protect_from_forgery :except => [:create, :delete, :update]

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end
  
  def show
    entry = retrieve_service.execute(name: params[:id])
    return not_found unless entry
    respond_to do |format|
      format.html do
      end
      format.json do
        render json: entry, status: :ok
      end
    end
  end

  def create
    result = create_service.execute(entry_params)
    respond_to do |format|
      format.html do
        redirect_to root_path(page: result[:page])
      end
      format.json do
        render json: { status: :ok }
      end
    end
  end

  def index
    @entries = retrieve_service.execute(query_options)
    return not_found if @entries.blank?
    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @entries
      end
    end
  end

  def destroy
    result = delete_service.execute(name: params[:id])
    return not_found unless result

    respond_to do |format|
      format.html do
        redirect_to root_path
      end
      format.json do
        render json: { status: 'ok' }, status: 200
      end
    end
  end

  private

  def create_service
    Boards::UpdateService.new
  end

  def retrieve_service
    Boards::GetAllService.new
  end

  def delete_service
    Boards::DeleteService.new
  end

  def entry_params
    (params[:entry] || {}).slice(:name, :score)
  end
end
