class Cell < ApplicationRecord
  belongs_to :board
  validates :position, presence: true, inclusion: { in: 0..80 }
  validates :content, inclusion: { in: 1..9 }, allow_nil: true

  def as_json
    {
      position: position,
      content: content,
      frozen: !content.nil?
    }
  end
end
