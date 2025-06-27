# Real-Time Updates for Externally Modified Data in Rails 8

## Step 1: The View (`index.html.erb`)

The foundation of the component is a `turbo_frame_tag`. This tag designates a section of the page that can be updated independently without a full page reload.  
We will attach our Stimulus controller directly to this frame and provide it with the necessary configuration—the URL to poll and the interval—via `data-*` attributes, which Stimulus automatically maps to controller values.

A particularly effective pattern is to use the `src` attribute on the `turbo_frame_tag`. This instructs Turbo to automatically load the frame's initial content from the specified URL as soon as the page renders. This avoids rendering the initial content twice (once on the main page load and again on the first poll).

```erb
<%# app/views/items/index.html.erb %>
<h1>Live Items Dashboard</h1>

<%= turbo_frame_tag "items_list",
                    src: items_path(format: :turbo_stream),
                    data: {
                      controller: "polling",
                      polling_url_value: items_path(format: :turbo_stream),
                      polling_interval_value: 5000
                    } do %>
  <div class="p-4 text-center text-gray-500">
    <p>Loading latest items...</p>
  </div>
<% end %>
```

**In this setup:**
- `turbo_frame_tag "items_list"` creates the container for our dynamic content.
- `src: items_path(format: :turbo_stream)` tells Turbo to immediately fetch the content for this frame from the `items#index` action, requesting the turbo_stream format.
- `data-controller="polling"` connects this DOM element to our `polling_controller.js`.
- `data-polling-url-value` and `data-polling-interval-value` pass server-side configuration to the Stimulus controller.

---

## Step 2: The Stimulus Controller (`polling_controller.js`)

The Stimulus controller is the heart of the polling logic. It manages the `setInterval` timer, initiating and terminating the polling based on the element's presence in the DOM. When the `turbo_frame_tag` is added to the page, the `connect` method is called. If the frame is ever removed, `disconnect` is called, which cleanly stops the timer and prevents memory leaks.

There are a few ways to trigger the frame's refresh. One approach is to manually re-set the `src` attribute of the frame element.  
A more elegant and Turbo-specific technique leverages an internal attribute of Turbo Frames. When a frame with a `src` attribute successfully loads its content, Turbo adds a `complete` attribute to the element to prevent it from reloading. By programmatically removing this `complete` attribute, we can trick Turbo into re-issuing the request for the `src` URL on our desired interval. This is a clever, lightweight method that works directly with Turbo's own lifecycle.

```js
// app/javascript/controllers/polling_controller.js
import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="polling"
export default class extends Controller {
  static values = {
    // The URL to fetch for updates.
    url: String,
    // The polling interval in milliseconds.
    interval: { type: Number, default: 5000 }
  }

  connect() {
    this.startPolling();
  }

  disconnect() {
    this.stopPolling();
  }

  startPolling() {
    // If a timer is already running, clear it first.
    this.stopPolling();

    this.timer = setInterval(() => {
      // This clever trick forces Turbo to reload the frame by making it
      // think the initial `src` load was never completed.
      // This is more idiomatic than manually fetching and replacing content.
      this.element.removeAttribute('complete');
    }, this.intervalValue);
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }
}
```

---

## Step 3: The Controller Action (`items_controller.rb`)

The Rails controller action that responds to the polling request must be prepared to handle a `turbo_stream` format. Its job is to query the database for the current state of the data and render a response that will update the `turbo_frame_tag` on the client side.

```ruby
# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  def index
    @items = Item.order(created_at: :desc).limit(10)

    respond_to do |format|
      # This handles the initial HTML page load.
      format.html

      # This handles the polling requests from our Stimulus controller.
      # By convention, this will look for and render `app/views/items/index.turbo_stream.erb`.
      format.turbo_stream
    end
  end
end
```

---

## Step 4: The Turbo Stream View (`index.turbo_stream.erb`)

Instead of returning a full HTML page, the controller action renders a Turbo Stream view. This view contains specific instructions for the client. In this case, we want to replace the entire content of our `items_list` frame with the newly rendered partial.

```erb
<%# app/views/items/index.turbo_stream.erb %>
<%= turbo_stream.replace "items_list" do %>
  <%= render partial: "items_list", locals: { items: @items } %>
<% end %>
```

This template tells Turbo: "Find the element with the ID `items_list` and replace its entire inner HTML with the content generated by the `_items_list` partial."

---

## Step 5: The Partial (`_items_list.html.erb`)

This partial contains the actual list of items. A critical detail for continuous polling is that this partial must re-render the exact same `turbo_frame_tag` that it is replacing, complete with the same ID and `data-*` attributes for the Stimulus controller.  
When Turbo replaces the frame, it also replaces the Stimulus controller's element. By including the controller declaration in the response, we ensure that Stimulus immediately reconnects a new instance of the `polling_controller` to the updated frame, and the polling cycle continues seamlessly.

```erb
<%# app/views/items/_items_list.html.erb %>
<%= turbo_frame_tag "items_list",
                    data: {
                      controller: "polling",
                      polling_url_value: items_path(format: :turbo_stream),
                      polling_interval_value: 5000
                    } do %>
  <ul class="divide-y divide-gray-200">
    <% items.each do |item| %>
      <li class="p-4">
        <p class="font-bold"><%= item.name %></p>
        <p class="text-sm text-gray-600">Created: <%= item.created_at.to_formatted_s(:long) %></p>
      </li>
    <% end %>
  </ul>
<% end %>
```
