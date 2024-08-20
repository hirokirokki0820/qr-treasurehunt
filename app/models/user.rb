class User < ApplicationRecord
  before_create :set_user_id

  private
    def set_user_id
      while self.id.blank? || User.find_by(id: self.id).present? do
        self.id = SecureRandom.base36
      end
    end
end
