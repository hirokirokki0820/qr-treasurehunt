class Post < ApplicationRecord
  before_create :set_post_id
  belongs_to :user
  has_many :items, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100}

  private
  def set_post_id
    while self.id.blank? || User.find_by(id: self.id).present? do
      self.id = SecureRandom.base58
    end
  end
end
