module Helper

  #helps check user choices for password, username, email etc.
  class Checker

    @database = Marketplace::Database.instance

    def self.check_password?(user, input_password)
      proper_password = BCrypt::Password.new(user.password)
      proper_password == input_password
    end

  end

end