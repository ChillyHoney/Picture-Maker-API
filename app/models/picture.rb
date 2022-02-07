class Picture < ApplicationRecord
  has_one_attached :file
  validates :file, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
            size: { less_than: 5.megabytes , message: :invalid_size }
end
