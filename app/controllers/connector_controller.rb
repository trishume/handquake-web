class ConnectorController < ApplicationController
  API_KEY = "AIzaSyCukMMJWtlgcB1F41cSjJK_A_Q0yZ5UT6k"
  WIT_TOKEN = "XU3JD7XDJNYBNEDU6J5EZHYOBS2OHNZ3"
  before_action :authenticate_user!
  def connect
    place_query = connect_params[:place]
    pos = get_latlon(place_query)
    if pos
      render json: {'status'=>'ok','q'=>place_query,'lat'=>pos[0], 'lon'=>pos[1]}
    else
      render json: {'status'=>'fail'}
    end
  end

  def wit
    @me = current_user
    @event = search_event("I met them " + wit_params[:message], @me)
    if @event
      @event.connect_to_user(@me)
      @name = @event.user.name
    else
      flash[:error] = "Couldn't find a connection"
      redirect_to profile_path, alert: "Couldn't find a connection, fool!"
    end

  end

  private
  def connect_params
    params.permit(:place, :time)
  end
  def wit_params
    params.permit(:message)
  end

  def wit_placetime(message)
    client = Wit::REST::Client.new(token: WIT_TOKEN)
    session = client.session
    r = session.send_message(message)
    r = r.entities()
    return nil unless r['location'] && r['datetime']
    loc = r['location'].first['value']
    ll = get_latlon(loc)
    [Time.parse(r['datetime'].first['value']['from']), ll]
  end

  def get_latlon(place_query)
    client = GooglePlaces::Client.new(API_KEY)
    places = []
    5.times do
      begin
        places = client.spots_by_query(place_query)
        break
      rescue
        sleep 0.2
      end
    end
    return nil unless p = places.first
    [p.lat, p.lng]
  end

  def search_event(message, user)
    r = wit_placetime(message)
    HandEvent.find_prox(r[1][0],r[1][1],r[0],user)
  end
end
