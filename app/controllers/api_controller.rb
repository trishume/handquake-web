class ApiController < ApplicationController
  def create_event
    p = event_params
    @user = User.find(p[:user])
    event = @user.hand_events.create(latitude: p[:lat].to_f, longitude: p[:lon].to_f)
    event.time = DateTime.now
    event.save!
    render json: {"status"=>"ok", "event_id"=>event.id}
  rescue => e
    render json: {"status"=>"fail", "message"=>e.message}
  end

  private
  def event_params
    params.permit(:user, :lat, :lon, :dir)
  end
end
