# frozen_string_literal: true

class User < ActiveRecord::Base  
  extend Devise::Models #added this line to extend devise model
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many_attached :pictures

  VALID_USERNAME_REGEX= /^(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/ix
  validates :username, presence: true, length: {minimum:3, maximum:26},
            format: { with: VALID_USERNAME_REGEX, :multiline => true,
            message: :invalid_username }
  validate :password_complexity


  def password_complexity
    return if password.blank? || password =~ /^((?!.*[\s]))/
    errors.add :password, :invalid_password
  end
end