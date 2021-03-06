class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :show, :new, :edit, :update, :destroy]

  # GET /locations
  def index
    @locations = Location.all
  end

  # GET /locations/1
  def show
    @location = Location.find(params[:id])
  end

  # GET /locations/nearby
  def nearby
    if(params.has_key?(:lat) && params.has_key?(:lng) && params.has_key?(:distance))
      begin
        lat = Float(params[:lat])
        lng = Float(params[:lng])
        distance = Float(params[:distance])
        @locations = Location.near([lat, lng], distance, :units => :km)
      rescue
        @locations = Location.all
      end
    else
      @locations = Location.all
    end
    render json: @locations
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = 'Location was successfully created.'
      redirect_to @location
    else
      render :new
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      flash[:success] = 'Location was successfully updated.'
      redirect_to @location
    else
      render :edit
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
    flash[:success] = 'Location was successfully destroyed.'
    redirect_to locations_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end
    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:latitude, :longitude, :description,
      :points, :hint1, :hint1_points, :hint2, :hint2_points, :area, :image)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.is_admin?
    end


end
