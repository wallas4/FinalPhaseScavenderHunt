class Event < ActiveRecord::Base
    has_and_belongs_to_many :locations
    has_and_belongs_to_many :participants
    has_one :roster
end
