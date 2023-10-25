import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  updateItemsFromLocalStorage() {
    const allImageData = this.collectImageDataFromLocalStorage();
    const tierId = this.getAttributeFromElement(document, "#tier-container", "data-tier-id");

    if (allImageData.length > 0) {
      this.postImageDataToServer(allImageData, tierId);
    } else {
      this.redirectToTierPage(tierId);
    }
  }

  collectImageDataFromLocalStorage() {
    const allImageData = [];
    const keysToRemove = [];

    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i);
      if (key.startsWith('imageData-')) {
        const storedData = localStorage.getItem(key);
        if (storedData) {
          const parsedData = this.parseImageData(storedData, key);
          allImageData.push(parsedData);
          keysToRemove.push(key);
        }
      }
    }

    this.removeKeysFromLocalStorage(keysToRemove);
    return allImageData;
  }

  parseImageData(storedData, key) {
    const parsedData = JSON.parse(storedData);
    const itemId = key.split('imageData-')[1];
    parsedData.item_id = itemId;
    return parsedData;
  }

  removeKeysFromLocalStorage(keysToRemove) {
    for (const key of keysToRemove) {
      localStorage.removeItem(key);
    }
  }

  postImageDataToServer(imageData, tierId) {
    fetch(`/tiers/${tierId}/items/bulk_update_items`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.getCsrfToken()
      },
      body: JSON.stringify(imageData)
    })
    .then(response => {
      if (response.ok) {
        this.redirectToTierPage(tierId);
      } else {
        throw new Error('Network response was not ok');
      }
    })
    .catch(error => {
      console.error('There was a problem with the fetch operation:', error.message);
    });
  }

  redirectToTierPage(tierId) {
    window.location.href = `http://localhost:3000/tiers/${tierId}`;
  }

  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }
  getAttributeFromElement(element, selector, attribute) {
    return element.querySelector(selector).getAttribute(attribute);
  }
}
