json.array!(@participants) do |participant|
  json.extract! participant, :id, :email
  json.url participant_url(participant, format: :json)
end
