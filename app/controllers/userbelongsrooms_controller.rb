class UserbelongsroomsController < ApplicationController
  def index
    @user_id = UserBelongsRoom.where(room_id: params[:room_id]).pluck("user_id")
    users = User.where(id: @user_id)
    render json: users
  end

  def user_ids
    @user_id = UserBelongsRoom.where(room_id: params[:room_id]).pluck("user_id")
    render json: @user_id
  end

  def create
    userbelong = UserBelongsRoom.new
    userbelongs_params[:user_id].each do |t|
      userbelong.user_id = t
      userbelong.room_id = userbelongs_params[:room_id]
      userbelong.save
    end
    render json: { status: :created }
  end

  def destroy
    userbelong = UserBelongsRoom.find_by(user_id: params[:user_id], room_id: params[:room_id])
    userbelong.destroy!
    render json: {status: :deleted}
  end

  private
    def userbelongs_params
      params.require(:belong).permit(:room_id, user_id: [])
    end
end
