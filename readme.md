# CS 270 - Spring 2015 - QR Code Scavenger Hunt - Phase 6

In this final phase of the project, we will bring together all of the
infrastructure we have created thus far to produce a working example of
a scavenger hunt.

At the core of what we want to do is to facilitate a check-in pipeline
that allows a participant to scan a QR code, input their credentials,
and update their list of locations still to visit.

The pipeline, therefore, will look like this:

1. Generate the QR code on the Location show page
2. Scan the QR code
3. Redirect to input page
4. Input participant credentials
5. Add the location to the participant list of locations
6. Redirect to participant show page, and
7. Display locations still to visit for each participant event

One thing to note before leaping in is that this entire process occurs
within a certain context, namely, all of this happens under the auspices
of a particular event.  So, we need to keep track of at least event
information throughout the pipeline, and as we will see other
information as well.

One other thing to note is that the logical assumption to make is that
when an event is created, the event manager will most likely assign
participants and locations to that event as well.  Thus, we update our
seeds.rb file to associate Events/Locations and Events/Participants:

```
# associate Events and Locations as follows
# event_id | location_id
# ----------------------
#     1          1
#     1          2
Event.find(1).locations << Location.find(1)
Event.find(1).locations << Location.find(2)

# associate Events and Participants as follows
# event_id | participant_id
# -------------------------
#     1            1
#     1            2
Event.find(1).participants << Participant.find(1)
Event.find(1).participants << Participant.find(2)
```

Reset the database, and we are ready to go!

## Updating Routes and QR Code

The pipeline will look like this:

![Check-in Pipeline](pipeline.jpg "Check-in Pipeline")

Because we need to keep track of event information, we start by
modifying the location show page URL to contain an event id, in the form
`http://domain/locations/event_id/location_id`.  This necessitates a
routing update in config/routes.rb:

`get 'locations/:event_id/:tag' => 'locations#show'`

Now we need to pass that same information when we scan the QR code and
redirect to the participant input page.  We incorporate that into our QR
code object when we generate the QR code URL:

```
@event = Event.find(params[:event_id])
@qr = RQRCode::QRCode.new("http://#{request.host}/#{@event.id}#{@location.tag}", :size => 8)
```

## Participant input page

But where will we redirect to when we scan a QR code?  The easiest
solution is to create a separate controller that handles the check-in
processing.  In this case, when we scan a QR code, we want to redirect
to a page that has a URL of the form
`http://domain/event_id/location_tag`.  We will map this route to an
index action inside this separate controller, which we will call the
CheckIn controller:

`get '/:event_id/:tag' => 'check_in#index'`

This obviously necessitates creating the actual controller:

`rails g controller check_in index success`

We will use the success action in just a moment to handle processing
when we click "submit" on the input page.

Now, we need to keep track of not only event information, but also
location information.  We can do so by instantiating an event object and
a location object using the parameters we passed in via the URL:

```
def index
  @event = Event.find(params[:event_id])
  @location = Location.find_by(tag: params[:tag])
```

This allows us to use those values in the input form.  The input form is
generated from the index.html.erb file in the newly create check_in view
folder, and for our purposes will simply contain a field to type in a
participant email.  It should look like this:

```
<h1>Check in for Location <%= @location.id %></h1>

<%= form_tag('/success') do %>
  <div class="field">
    <%= label_tag :email %><br>
    <%= text_field_tag :email %>
  </div>

  <%= hidden_field_tag :location_id, @location.id %>
  <%= hidden_field_tag :event_id, @event.id %>

  <div class="actions">
    <%= submit_tag "Check in" %>
  </div>
<% end %>
```
