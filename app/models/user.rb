# frozen_string_literal: true

class User < ActiveRecord::Base

  extend Devise::Models #added this line to extend devise model
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :authentication_keys => [:username, :email]
  include DeviseTokenAuth::Concerns::User  

  validates :username, presence: true, length: {minimum:3, maximum:26},
             uniqueness: true  
end
