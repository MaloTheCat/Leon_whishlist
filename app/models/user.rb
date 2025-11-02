class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :gifts, dependent: :destroy
  has_many :reserved_gifts, class_name: 'Gift', foreign_key: 'reserved_by_id'

  def has_uploaded_gifts?
    gifts.any?
  end

  def group_members_gifts(group)
    return Gift.none unless groups.include?(group)
    
    group.users.where.not(id: id).flat_map(&:gifts)
  end
end
