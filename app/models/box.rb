class Box < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1 }
  validates :user, presence: true

  belongs_to :user
  has_many :foods
  has_many :invitations

  scope :owned_by, ->(user) { where(user: user) }
  scope :inviting, ->(user) { joins(:invitations).where(invitations: { user: user }) }
  scope :all_with_invited, ->(user) { owned_by(user) + inviting(user) }

  def is_owned_by(user)
    user.boxes.include?(self)
  end

  def is_inviting(user)
    invitations.map(&:user).include?(user)
  end

  def is_accessible_for(user)
    is_owned_by(user) || is_inviting(user)
  end
end
