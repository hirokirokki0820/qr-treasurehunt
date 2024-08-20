class User < ApplicationRecord
  before_create :set_user_id
  has_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 30 }

  private
    def set_user_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.base36
      end
    end
end
