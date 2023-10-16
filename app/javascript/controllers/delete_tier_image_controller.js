import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  dragStart(event) {
    const imageId = event.currentTarget.dataset.imageId;
    event.dataTransfer.setData('image-id', imageId);
  }

  dragOver(event) {
    event.preventDefault();
  }

  drop(event) {
    const imageId = event.dataTransfer.getData('image-id');

    fetch(`/items/${imageId}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.status === 'success') {
        const imageElement = document.querySelector(`[data-image-id="${imageId}"]`);
        if (imageElement) {
          imageElement.remove();
        }
      }
    });
  }
}
