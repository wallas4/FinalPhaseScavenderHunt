json.array!(@rosters) do |roster|
  json.extract! roster, :id, :event_id, :location_id, :participant_id
  json.url roster_url(roster, format: :json)
end
