class User < ApplicationRecord
  validates :user_name, :password_digest, :session_token, presence:true
  validates :user_name, :session_token, uniqueness:true
  validates :password, length: {minimum: 6, allow_nil: true}
  
  after_initialize :ensure_session_token
  attr_reader :password
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_object = BCrypt::Password.new(self.password_digest)
    password_object.is_password?(password)
  end

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

end
