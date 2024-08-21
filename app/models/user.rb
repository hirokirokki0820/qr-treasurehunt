class User < ApplicationRecord
  before_create :set_user_id
  has_many :posts, dependent: :destroy

  # ユーザー名のバリデーション
  VALID_NAME_REGEX = /\A[a-zA-Z0-9]+\z/ # 半角アルファベット(大文字・小文字・数値)のみ
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 30 },
  format: { with: VALID_NAME_REGEX }, if: :require_validation?

  # パスワードのバリデーション
  has_secure_password validations: false
  validate(if: :require_validation?) do |record|
    record.errors.add(:password, :blank) unless record.password_digest.present?
  end
  validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED, if: :require_validation?
  validates_confirmation_of :password, allow_blank: true, if: :require_validation?
  validates :password,
                      length: { minimum: 6 }, if: :require_validation?

  private
    # ゲストユーザーのみバリデーションを解除（Name, Password）
    def require_validation?
      return true if self.guest == false || self.guest == 0
      false
    end

    # ランダムなユーザーIDを生成
    def set_user_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.base58
      end
    end

    # ランダムなユーザー名を生成(ゲストアカウント用)
    def set_guest_user_name
      while self.name.blank? || User.find_by(name: self.name).present? do
        self.name = SecureRandom.base36
      end
    end
end
