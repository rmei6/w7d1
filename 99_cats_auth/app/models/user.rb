class User < ApplicationRecord
  validates :user_name, :password_digest, :session_token, presence:true
  validates :user_name, :session_token, uniqueness:true
  
  after_initialize :ensure_session_token

  def self.find_by_credentials(user_name, password)
    
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
end
