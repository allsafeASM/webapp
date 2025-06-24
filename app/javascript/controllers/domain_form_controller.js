import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  clearForm(event) {
    if (event.detail.success) {
      this.inputTarget.value = ""
    }
  }
  reset() {
    this.element.reset()
  }
}
