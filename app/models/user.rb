class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token, :reset_token
    # ユーザー登録関係
    before_save :downcase_email
    before_create :create_activation_digest
    validates :name,  presence: true, length: { maximum: 10 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    has_one :profile, dependent: :destroy

    has_many :posts, dependent: :destroy

    has_many :relationships, dependent: :destroy
    has_many :followings, through: :relationships, source: :follow, dependent: :destroy
    has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
    has_many :followers, through: :reverse_of_relationships, source: :user, dependent: :destroy

    # 渡された文字列のハッシュ値を返す
    def self.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def User.new_token
      SecureRandom.urlsafe_base64
    end

    # 永続セッションのためにユーザーをデータベースに記憶する
    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    # ユーザーのログイン情報を破棄する
    def forget
      update_attribute(:remember_digest, nil)
    end

    # トークンがダイジェストと一致したらtrueを返す
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    # アカウントを有効にする
    def activate
      update_attribute(:activated, true)
      update_attribute(:activated_at, Time.zone.now)
    end

    # 有効化用のメールを送信する
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    # パスワード再設定の属性を設定する
    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest,  User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end

    # パスワード再設定のメールを送信する
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    # パスワード再設定の期限が切れている場合はtrueを返す
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end

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

      def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
      end
end
