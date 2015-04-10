class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.references :event, index: true
      t.references :location, index: true
      t.references :participant, index: true

      t.timestamps
    end
  end
end
