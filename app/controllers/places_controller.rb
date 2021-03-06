class PlacesController < PublicController
  
  before_action :get_places, only: [:index]
  
  def index
    respond_to do |format|
      format.json do
        render json: @places.as_json(methods: :route_count)
      end
    end
  end
  
  private
  
    def places_params
      params.permit(:query)
    end
    
    def get_places
      @places = Place.all
      @places = @places.where("name ILIKE ?", "#{places_params[:query]}%") if places_params[:query]
    end

end
