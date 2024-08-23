class Item < ApplicationRecord
  before_create :set_item_id
  belongs_to :post

  validates :name, presence: true, length: { maximum: 50 }

  # ransack のホワイトリスト登録メソッド
  def self.ransackable_attributes(auth_object = nil)
    ["name", "item_got_user"]
  end

  private
    # item用のidを生成
    def set_item_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.urlsafe_base64
      end
    end
end
