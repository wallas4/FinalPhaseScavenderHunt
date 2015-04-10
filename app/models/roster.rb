class Roster < ActiveRecord::Base
  belongs_to :event
  belongs_to :location
  belongs_to :participant
end
