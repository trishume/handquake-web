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

    if user.update(p)
      render json: {"status"=>"ok"}
    else
      render 'edit'
    end
  end

  private
  def update_params
    params.permit(:id, :pebble, :info, :name)
  end
end
