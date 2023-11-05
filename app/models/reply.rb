class Reply < ApplicationRecord
  belongs_to :post, class_name: 'Post'
  belongs_to :reply, class_name: 'Post'
end