class Review < ApplicationRecord
  belongs_to :reviewer, class_name: :user
  belongs_to :reviewable, polymorphic: true
end
