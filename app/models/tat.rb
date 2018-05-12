class Tat < ApplicationRecord
  has_many :contents, class_name: 'TatContent', dependent: :destroy
  has_one :target, class_name: 'TatTarget', dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :contents
  accepts_nested_attributes_for :target

  before_validation :ensure_user

  def ensure_user
    return if self.user
    self.user = User.create_temporary
  end

  def self.by_target(target_params)
    Tat.joins(:target)
      .where 'tat_targets.identifier = ? AND tat_targets.type = ?',
      target_params[:identifier], target_params[:type]
  end
end
