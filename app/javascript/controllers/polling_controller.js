import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]
  static values = { interval: { type: Number, default: 10000 } }

  connect() {
    this.startPolling()
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.stopPolling() // Clear any existing timers
    this.timer = setInterval(() => {
      // Turbo adds the `busy` attribute during a network request.
      // We only trigger a reload if the frame is not currently busy.
      if (!this.frameTarget.hasAttribute("busy")) {
        this.frameTarget.reload()
      }
    }, this.intervalValue)
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }
}
