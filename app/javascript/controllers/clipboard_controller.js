// app/javascript/controllers/clipboard_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text", "icon"]
  
  copy() {
    navigator.clipboard.writeText(this.element.dataset.clipboardText)
    
    // Update UI to show copied state
    this.textTarget.textContent = "Copied!"
    this.iconTarget.innerHTML = this.checkIcon
    
    // Reset after 2 seconds
    setTimeout(() => {
      this.textTarget.textContent = "Copy"
      this.iconTarget.innerHTML = this.copyIcon
    }, 2000)
  }

  get checkIcon() {
    return `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
    </svg>`
  }

  get copyIcon() {
    return `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
    </svg>`
  }
}