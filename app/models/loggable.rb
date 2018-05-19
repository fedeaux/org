class Loggable < ApplicationRecord
  belongs_to :user

  default_scope ->{ order(:name) }
end
