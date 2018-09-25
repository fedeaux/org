class Loggable < ApplicationRecord
  has_ancestry
  belongs_to :user
  default_scope ->{ order(:name) }

  before_save :ensure_attributes
  has_many :logs

  def ensure_attributes
    return unless parent
    self.background_color ||= parent.background_color
    self.text_color ||= parent.text_color
  end

  def logs_with_descendents
    Log.where(loggable_id: [id] + descendant_ids)
  end
end
