class CheckInController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @location = Location.find_by(tag: params[:tag])
  end

  def success
  @event = Event.find(params[:event_id])
  @location = Location.find(params[:location_id])
  @participant = Participant.find_by(email: params[:email])

  respond_to do |format|
    if Roster.create(event_id: @event.id, location_id: @location.id, participant_id: @participant.id)
      format.html { redirect_to participant_path(id: @participant.id, event_id: @event.id), 
    notice: 'Participant was successfully checked in.' }
      format.json { render :show, status: :updated, participant: @participant }
    else
      format.html { render :new }
      format.json { render json: @participant.errors, status: :unprocessable_entity }
    end
  end
  end
end
