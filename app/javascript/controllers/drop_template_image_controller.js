import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drop-template-image"
export default class extends Controller {
  connect() {
    this.draggedImageId = null;
  }

  dragOver(event) {
    event.preventDefault();
  }

  dragStart(event) {
    console.log("dragStart");
    this.draggedImageId = event.target.getAttribute("data-image-id");
  }

  dropTemplateImage(event) {
    event.preventDefault();
    if (this.draggedImageId) {
      const imageId = this.draggedImageId;
      document.getElementById('drop_image').value = imageId;
    }
    const form = this.element.querySelector('form');
    form.requestSubmit();
  }
}
