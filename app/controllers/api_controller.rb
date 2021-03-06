class ApiController < ApplicationController
  def create_event
    p = event_params
    user = User.find_by(pebble: p[:id])
    raise "Invalid user" unless user
    event = user.hand_events.create(latitude: p[:lat].to_f, longitude: p[:lon].to_f)
    event.time = DateTime.now
    event.save!
    if conn = event.try_connect
      event.pushed = true
      event.save!
      render json: connected_response(event, conn)
    else
      render json: {"status"=>"ok", "event_id"=>event.id}
    end
  rescue => e
    render json: {"status"=>"fail", "message"=>e.message}
  end

  def poll_event
    event = HandEvent.find(poll_params[:event])
    if conn = event.try_connect
      event.pushed = true
      event.save!
      render json: connected_response(event, conn)
    elsif event.to_late?
      render json: {"status"=>"godie"}
    else
      render json: {"status"=>"no"}
    end
  rescue => e
    render json: {"status"=>"fail", "message"=>e.message}
  end

  private
  def event_params
    params.permit(:id, :lat, :lon, :dir)
  end
  def poll_params
    params.permit(:event)
  end
  def connected_response(event, conn)
    other = conn.find_other(event.user.id)
    {
      "status"=>"found", "event_id"=>event.id,
      "conn_id"=>conn.id, "name"=>other.name,
      "profile"=>other.info
    }
  end
end
