class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tats

  def self.create_temporary
    random_part = "#{Time.now.to_i}-#{rand(1000)}"
    email = "tatuser_#{random_part}@tatuser.com"

    User.create(
      email: email,
      password: ENV['TEMP_USER_PASSWORD'],
      password_confirmation: ENV['TEMP_USER_PASSWORD'])
  end

  def self.ensure_temporary(user_id)
    return create_temporary unless user_id
    User.find user_id
  end
end
