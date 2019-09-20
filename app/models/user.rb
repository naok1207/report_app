class User < ApplicationRecord
    # ユーザー登録関係
    before_save :downcase_email
    validates :name,  presence: true, length: { maximum: 10 }
    validates :email, presence: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    has_one :profile

    has_many :posts

    private
      def downcase_email
        self.email = email.downcase
      end
end
