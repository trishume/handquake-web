class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    user = current_user
    p = update_params
    p[:info] = JSON.parse(p[:info]) if p[:info]
    p[:info].select! {|x| x && !x.empty?}

    if user.update(p)
      render json: {"status"=>"ok"}
    else
      render 'edit'
    end
  end

  def new_changes
    q = Connection.where(["id > ?",params.require(:last_seen)])
    res = q.count
    if res > 0
      render json: {'status'=>'new', 'new'=>res, 'last'=>q.last.id}
    else
      render json: {'status'=>'nope'}
    end
  end

  private
  def update_params
    params.permit(:id, :pebble, :info, :name)
  end
  def poll_params
    params.permit(:last_seen)
  end
end
