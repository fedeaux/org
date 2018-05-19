user = User.where(email: 'phec06@gmail.com').first_or_initialize
user.assign_attributes(password: 'test1234', password_confirmation: 'test1234')
user.save
