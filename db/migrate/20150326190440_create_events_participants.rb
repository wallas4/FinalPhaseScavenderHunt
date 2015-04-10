class CreateEventsParticipants < ActiveRecord::Migration
  def change
    create_table :events_participants, id: false do |t|
        t.belongs_to :participant, index:true
        t.belongs_to :event, index:true
    end
  end
end
