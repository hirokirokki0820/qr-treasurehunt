class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

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

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.guest == true || @user.guest == 1
      redirect_to root_path, alert: "ゲストアカウントは削除できません。"
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: "アカウントが削除されました。" }
        format.json { head :no_content }
      end
    end
  end

  def guest_login
    if current_user
      redirect_to current_user, alert: "すでにログインしています。"
    else
      user = User.create!(name: "Guest", guest: true)
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

    # ゲストユーザーの設定
    # def set_guest_user
    #   # ランダムなゲストユーザー名を生成
    #   while @user.name.blank? || User.find_by(name: @user.name).present? do
    #     @user.name = SecureRandom.base36
    #   end
    #   # ゲストユーザーカラムをtrueにする
    #   @user.guest = true
    # end
end
