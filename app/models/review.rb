class Review < ApplicationRecord
  validates :comment, presence: true
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewable, polymorphic: true
end
