class Item < ApplicationRecord
  before_create :set_item_id
  belongs_to :post

  validates :name, presence: true, length: { maximum: 50 }

  private
  def set_item_id
    while self.id.blank? || User.find_by(id: self.id).present? do
      self.id = SecureRandom.urlsafe_base64
    end
  end
end
