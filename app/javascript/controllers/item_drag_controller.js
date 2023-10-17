import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  dragStart(event) {
    const imageId = event.currentTarget.dataset.imageId;
    event.dataTransfer.setData('image-id', imageId);
  }

  dragOver(event) {
    event.preventDefault();
  }

  deleteItem(event) {
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

  updateItem(event) {
    event.preventDefault();

    const itemId = event.dataTransfer.getData("image-id");
    const draggedElem = document.querySelector('[data-image-id="' + itemId + '"]');
    event.currentTarget.appendChild(draggedElem);

    const tierId = this.getAttributeFromElement(document, "#tier-container", "data-tier-id");
    let categoryId, rankId;

    if (event.currentTarget.id === 'default-area') {
      categoryId = this.getAttributeFromElement(document, "#default-area", "data-default-category-id");
      rankId = this.getAttributeFromElement(document, "#default-area", "data-default-rank-id");
    } else {
      categoryId = this.getTierCategoryId(event.currentTarget);
      rankId = this.getAttributeFromElement(event.currentTarget.parentElement, ".label-holder", "data-rank-id");
    }

    this.fetchUpdateItem(tierId, categoryId, rankId, itemId);
  }

  getAttributeFromElement(element, selector, attribute) {
    return element.querySelector(selector).getAttribute(attribute);
  }

  getTierCategoryId(cell) {
    const cellIndex = Array.from(cell.parentElement.children).indexOf(cell);
    const categoryRow = cell.parentElement.parentElement.querySelector(".category-row");
    const categoryLabel = categoryRow.children[cellIndex];
    return categoryLabel.getAttribute("data-category-id");
  }

  fetchUpdateItem(tierId, categoryId, rankId, itemId) {
    fetch(`/tiers/${tierId}/items/${itemId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.getCsrfToken()
      },
      body: JSON.stringify({
        category_id: categoryId,
        rank_id: rankId
      })
    })
    .then(response => {
      if (!response.ok) throw new Error('Network response was not ok');
      return response.json();
    })
    .then(data => {
      // handle success if needed
    })
    .catch(error => {
      console.error('There was a problem with the fetch operation:', error.message);
    });
  }

  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }
}
