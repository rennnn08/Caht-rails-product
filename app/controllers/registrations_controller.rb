class RegistrationsController < ApplicationController
  def signup
    if User.exists?(email: registrations_params[:email])
      render json: { status: 500, errors: '既に登録されているメールアドレスです' }
    end
    @user = User.new(registrations_params)
    if @user.save
      login!
      render json: { status: :created, user: @user }
    elsif 
      render json: { status: 500, errors: 'アカウント作成に失敗しました' }
    end
  end

  private
    def registrations_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
