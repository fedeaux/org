class Loggable < ApplicationRecord
  has_ancestry
  belongs_to :user
  default_scope ->{ order(:name) }

  before_save :ensure_attributes

  def ensure_attributes
    return unless parent
    self.background_color ||= parent.background_color
    self.text_color ||= parent.text_color
  end
end
