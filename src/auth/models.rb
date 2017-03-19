require 'sequel'
require 'argon2'


##
# Class that represents a registerd user. This stores basic
# information like the user's email address and hashed
# password.
#
class User < Sequel::Model

  ##
  # Check if this user is authenticated. This will always
  # return true for non-anonymous users.
  #
  def authenticated?
    true
  end

  ##
  # Set or update the user's password. This will calculate
  # the password hash using the Argon2 library.
  #
  def set_password(password)
    self.password = Argon2::Password.create(password)
  end

  ##
  # Check if the given password matches the one stored in
  # the database. This will use the Argon2 library to
  # perform a constant time comparison of the passwords.
  #
  def verify_password(password)
    Argon2::Password.verify_password(password, self.password)
  end
end


##
# Class that represents an unauthenticated user.
#
class AnonymousUser

  ##
  # Check if this user is authenticated. This will always
  # return false for anonymous users.
  #
  def authenticated?
    false
  end
end
