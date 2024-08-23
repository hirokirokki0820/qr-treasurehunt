class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy show_qrcodes activation_reset_all ]
  before_action :require_same_user, only: %i[ show edit update destroy ]
  before_action :require_user, only: %i[ index ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    # @search = @post.items.ransack(params[:q])
    # @items = @search.result.page(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to post_url(@post), notice: "新規イベントが作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: "イベント名が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!
    redirect_to posts_url, notice: "イベントが削除されました。"
  end

  # QRコードを表示・印刷する
  def show_qrcodes
  end

  # 全ての景品の取得状態をリセットする
  def activation_reset_all
    @post.items.each do |item|
      if item.item_got_user? && !item.lose?
        item.update_attribute(:item_got_user, nil)
      end
    end
    redirect_to @post, notice: "景品の在庫状況がリセットされました。"
  end

  # 選択した景品の取得状況をリセットする
  def activation_reset

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title)
    end

    def require_same_user
      if current_user != @post.user
        flash[:alert] = "ご自身以外のアカウントの閲覧・編集はできません"
        redirect_to root_path
      end
    end
end
