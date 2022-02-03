class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :comment, presence: true

  # validates :book_comment,presence:true

end
