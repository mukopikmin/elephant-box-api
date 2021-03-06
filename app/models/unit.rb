# frozen_string_literal: true

class Unit < ApplicationRecord
  validates_presence_of :label
  validates_presence_of :user
  validates :step, presence: true,
                   numericality: { greater_than: 0 }
  validates_uniqueness_of :label, scope: :user

  belongs_to :user
  has_many :foods

  scope :owned_by, ->(user) { where(user: user) }

  def owned_by?(user)
    user.units.include?(self)
  end

  def inuse?
    !foods.empty?
  end
end
