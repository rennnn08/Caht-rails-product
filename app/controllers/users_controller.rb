class UsersController < ApplicationController
  def index
    users = User.search(params[:search]).select("id","name","password_digest","profile","image")
    render json: users
  end

  def show
    user = User.find(params[:user_id])
    render json: user
  end

  def update
    user = User.find(user_params[:user_id])
    if user.update(name: user_params[:name], profile: user_params[:profile], image: user_params[:image])
      bucket = Aws::S3::Resource.new(
        :region => 'ap-northeast-1',
        :access_key_id => 'AKIA5ZICG472ZZUC7ODH',
        :secret_access_key => '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',
      ).bucket('chat-storage08')
      bucket.object("user_id_#{user.id}_image").put(:body => user_params[:profile])
      render json: {status: :created, user: user}
    else
      render joson: {status: 401, errors: 'updateError'}
    end
  end

  def loginUser
    users = User.where(id: params[:user_ids])
    render json: users
  end

  private
    def user_params
      params.require(:user).permit(:user_id, :name, :profile, :image, user_ids: [])
    end
end
