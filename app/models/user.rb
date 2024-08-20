class User < ApplicationRecord
  before_create :set_user_id
  has_many :posts, dependent: :destroy

  # ユーザー名のバリデーション
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 30 }

  # パスワードのバリデーション
  has_secure_password
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true

  private
    # ランダムなユーザーIDを生成
    def set_user_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.base36
      end
    end

    # ランダムなユーザー名を生成(ゲストアカウント用)
    def set_guest_user_name
      while self.name.blank? || User.find_by(name: self.name).present? do
        self.name = SecureRandom.base36
      end
    end
end
