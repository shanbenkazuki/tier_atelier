import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  uploadImages() {
    this.element.querySelector('input[type="file"]').click();
  }

  submit() {
    this.element.querySelector('form').requestSubmit();
  }
}
