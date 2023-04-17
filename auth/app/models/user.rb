class User < ApplicationRecord
    before_validation :ensure_session_token
    validates :username, presence: true 
    validates :session_token, presence: true 
    validates :password_digest, presence: {message: "Password can't be blank"}
    validates :password, length: {minimum:6}, allow_nil: true 

    attr_reader :password 

    def find_by_credentials(username,password)
        user = User.find_by(username: username)

        if user && user.is_passowrd?(password)
            return user 

        else 
            return nil 
        end
    end

    def is_password?(passowrd)
        bcrypt_obj = Bcrypt::Password.new(self.password_digest)
        bcrypt_obj.is_password?(password)
    end

    def generate_unique_session_token
        SecureRandom::urlsafe_base64
    end

    def password=(password)
        self.password_digest = Bcrypt::Password.create(password)
        @password = password
    end

    def ensure_session_token 
        self.session_token ||= generate_session_token
    end

    def reset_session_token!
        self.session_token = generate_session_token
        self.save!
        self.session_token 

    end
end
