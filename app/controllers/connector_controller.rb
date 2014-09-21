class ConnectorController < ApplicationController
  API_KEY = "AIzaSyCukMMJWtlgcB1F41cSjJK_A_Q0yZ5UT6k"
  def connect
    place_query = connect_params[:place]
    client = GooglePlaces::Client.new(API_KEY)
    render json: {'q'=>place_query}
  end

  private
  def connect_params
    params.permit(:place, :time)
  end
end
