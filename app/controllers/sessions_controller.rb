class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(name: session_params[:name])
    if @user && @user.authenticate(session_params[:password])
      log_in @user
      flash[:notice] = "こんにちは、#{@user.name}さん"
      redirect_to @user
    else
      @user = User.new(session_params)
      flash.now[:error] = "ユーザー名またはパスワードに誤りがあります"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end

  private
  def session_params
    params.require(:session).permit(:name, :password)
  end
end
