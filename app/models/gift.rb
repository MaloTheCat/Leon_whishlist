class Gift < ApplicationRecord
  belongs_to :user
  belongs_to :reserved_by, class_name: 'User', optional: true

  has_one_attached :image

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def reserved?
    reserved_by_id.present?
  end

  def can_be_reserved_by?(user)
    !reserved? && user.id != self.user_id
  end
end
