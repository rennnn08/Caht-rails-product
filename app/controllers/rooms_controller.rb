class RoomsController < ApplicationController
  def index
    room_ids = UserBelongsRoom.where(user_id: params[:user_id]).pluck("room_id")
    rooms = Room.where(id: room_ids).includes(:users).order("id DESC")
    render json: rooms.as_json(include: :users )
  end

  def create
    if room = Room.where(name: room_params[:name])
      if UserBelongsRoom.exists?(room_id: room, user_id: room_params[:user_id])
        render json: {status:400, errors: '既に存在しているルーム名です' }
      else
        room = Room.new(name: room_params[:name])
        if room.save
          UserBelongsRoom.create(user_id:room_params[:user_id], room_id: room.id)
          room_ids = UserBelongsRoom.where(user_id: room_params[:user_id]).pluck("room_id")
          rooms = Room.where(id: room_ids).order("id DESC")
          render json: { status: :created, rooms: rooms }
        else
          render json: { status: 500, errors: 'error'}
        end
      end
    else
      room = Room.new(name: room_params[:name])
      if room.save
        UserBelongsRoom.create(user_id:room_params[:user_id], room_id: room.id)
        room_ids = UserBelongsRoom.where(user_id: room_params[:user_id]).pluck("room_id")
        rooms = Room.where(id: room_ids).order("id DESC")
        render json: { status: :created, rooms: rooms }
      else
        render json: { status: 500, errors: 'error'}
      end
    end
    
  end

  def toakcreate
    if room = Room.find_by(name: room_params[:name])
      if UserBelongsRoom.exists?(room_id: room, user_id: room_params[:user_id])
        render json: { room: room }
      else
        room = Room.new(name:room_params[:name])
        if room.save
          UserBelongsRoom.create(user_id:room_params[:user_id], room_id: room.id)
          UserBelongsRoom.create(user_id:room_params[:opponent_id], room_id: room.id)
          render json: { room: room }
        else
          render json: { status: 500, errors: 'error'}
        end
      end
    else
      room = Room.new(name:room_params[:name])
        if room.save
          UserBelongsRoom.create(user_id:room_params[:user_id], room_id: room.id)
          UserBelongsRoom.create(user_id:room_params[:opponent_id], room_id: room.id)
          render json: { room: room }
        else
          render json: { status: 500, errors: 'error'}
        end
    end
  end


  def show
    room = Room.find(params[:id])
    render json: room.as_json(include: :users )

  end

  def destroy
    room = Room.find(params[:id])
    if room.destroy
      render json: {status: :deleted}
    else
      render json: {status: 401}
    end
    
  end
  
  private
    def room_params
      params.require(:room).permit(:name, :user_id, :opponent_id)
    end
end
