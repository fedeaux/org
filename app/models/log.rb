class Log < ApplicationRecord
  belongs_to :loggable

  scope :on_day, ->(date) do
    bod = date.beginning_of_day
    eod = date.end_of_day

    where '(finish > :bod OR finish IS NULL) AND start < :eod', bod: bod, eod: eod
  end

  scope :by_loggable_id, ->(loggable_id) do
    where loggable_id: loggable_id
  end
end
