class User < ApplicationRecord
    # ユーザー登録関係
    before_save :downcase_email
    validates :name,  presence: true, length: { maximum: 10 }
    validates :email, presence: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    has_one :profile

    has_many :posts

    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverse_of_relationships, source: :user

    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end
  
    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
  
    def following?(other_user)
      self.followings.include?(other_user)
    end

    def followed?(current_user)
      self.followings.include?(current_user)
    end

    private
      def downcase_email
        self.email = email.downcase
      end
end
