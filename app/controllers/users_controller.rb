class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_verified_account, only: %i[ edit update destroy ]
  before_action :require_same_user, only: %i[ show edit update destroy ]
  before_action :require_user, only: %i[ index ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to user_url(@user), notice: "新規アカウントが作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      redirect_to user_url(@user), notice: "アカウント情報が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    redirect_to root_path, notice: "アカウントが削除されました。", status: :see_other
  end

  def guest_login
    if current_user
      redirect_to current_user, alert: "すでにログインしています。"
    else
      user = User.guest_login
      log_in user
      redirect_to user, notice: "ゲストとしてログインしました。"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    # ゲストユーザーに対する制限(編集・削除の禁止)
    def require_verified_account
      if @user.guest == true || @user.guest == 1
        redirect_to @user, alert: "ゲストアカウントの編集・削除はできません。"
      end
    end

    def require_same_user
      if current_user != @user
        flash[:alert] = "ご自身以外のアカウントの閲覧・編集はできません。"
        redirect_to root_path
      end
    end

end
