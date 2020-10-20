class MessagesController < ApplicationController
  def index
    @message = Message.where(room_id: params[:room_id]).includes(:user)
    render json: @message.as_json(include: { user: {only: [:id, :name, :image]}})
  end

  def create
    @message = Message.new(messages_params)
    if @message.save
      message = Message.where(room_id: params[:message][:room_id])
      ActionCable.server.broadcast "messages_channel_#{message[0].room_id}",message.as_json(include: { user: {only: :name}})
      render json: { status: :created, message: message.as_json(include: { user: {only: :name}}) }
    else
      render json: { status: 500 }
    end
  end

  private
    def messages_params
      params.require(:message).permit(:content, :room_id, :user_id)
    end
end
