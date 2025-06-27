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
