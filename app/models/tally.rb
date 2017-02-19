class Tally < ActiveRecord::Base
  belongs_to :candidate

  validates :win_count, numericality: { greater_than_or_equal_to: 0 }

  def win_inc!
    update!(win_count: win_count + 2)
  end

  def tie_inc!
    update!(win_count: win_count + 1)
  end
end
