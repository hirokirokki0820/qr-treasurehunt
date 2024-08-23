class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy activate_item ]
  before_action :set_post
  before_action :require_same_user, only: %i[ edit update destroy ]
  before_action :set_item_got_user, only: %i[ show ]
  # after_action :item_deactivate, only: %i[ show ]
  before_action :require_user, only: %i[ index show ]
  before_action :items_index, only: %i[ show activate_item ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.post = @post
    if @item.activated? && @item.lose == true
      @item.update_attribute(:activated, false)
    end
    if @item.save
      redirect_to @item.post, notice: "新規アイテムが追加されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    if @item.update(item_params)
      redirect_to @item.post, notice: "アイテムが更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!
    redirect_to post_path(@post), notice: "アイテムが削除されました。"
  end

  def activate_item
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :activated, :lose)
    end

    # 景品No. を返す
    def items_index
      @post.items.each_with_index do |item, index|
        if item.id == @item.id
          @index = index + 1
        end
      end
    end

    # item_got_userカラムに景品取得したユーザーIDを代入する
    def set_item_got_user
      if logged_in?
        if @item.item_got_user.nil? && !@item.lose?
          @item.update_attribute(:item_got_user, current_user.id)
        end
      end
    end

    # 一度アクセスしたら activated を無効化する
    def item_deactivate
      if @item.activated?
        @item.update_attribute(:activated, false)
      end
    end

    def require_same_user
      if current_user != @item.post.user
        flash[:alert] = "ご自身以外のアカウントの閲覧・編集はできません"
        redirect_to root_path
      end
    end
end
