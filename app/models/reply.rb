class Reply < ApplicationRecord
  #? am i sure i want touch in two directions here?

  belongs_to :post, class_name: 'Post', touch: true
  belongs_to :reply, class_name: 'Post', touch: true
end