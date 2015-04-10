# CS 270 - Spring 2015 - QR Code Scavenger Hunt - Phase 5

In this phase, we will generate a QR code to display for a Location.

## QR Code Generation

Recall that our Gemfile includes the `rqrcode` gem.  We will use this
gem to generate a QR code for each location based on the random tag.

The QR code for each location will come into play for the Location show
page.  Thus, we need to edit our app in several places to incorporate the QR code for
that location.

## Location Controller

First, we need to create a QR code object in the controller show action.
We can do that as follows:

`@qr = RQRCode::QRCode.new("http://#{request.host}/#{@location.tag}",
:size => 8)`

This creates an instance variable, `@qr`, that we can use in the show
view.

## Show Location Page

In the `show.html.erb` file, we need to write code to display the QR
object.  This code is given to us in the `rqrcode` documentation:

```
<table>
  <% @qr.modules.each_index do |x| -%>
    <tr>
    <% @qr.modules.each_index do |y| -%>
      <% if @qr.dark?(x,y) -%>
        <td class="black"/>
      <% else -%>
        <td class="white"/>
      <% end -%>
    <% end -%>
    </tr>
  <% end -%>
</table>
```

Thank goodness for documentation!

## QR Code Styling

We do need to incorporate some styling in our app to display the QR code
properly.  Notice there is an `assets` folder in the `app` directory:
this is where Rails maintains all the stylesheets for our application.

Navigate to the `app/assets/stylesheets` directory, and you will notice
a blank stylesheet has been created for the Location resource, called
`locations.css.scss`.  Edit this file per the `rqrcode` documentation to
include these styling rules:

```
table {
  border-width: 0;
  border-style: none;
  border-color: #0000ff;
  border-collapse: collapse;
}

td {
   border-width: 0;
   border-style: none;
   border-color: #0000ff;
   border-collapse: collapse;
   padding: 0;
   margin: 0;
   width: 10px;
   height: 10px;
}

td.black { background-color: #000; }
td.white { background-color: #fff; }
```

Once you have completed these tasks, fire up the Rails test server and
make sure that the Location show page displays the QR code properly.
