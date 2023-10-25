import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  updateItemsFromLocalStorage() {
    const allImageData = [];
    const keysToRemove = [];
  
    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i);
      if (key.startsWith('imageData-')) {
        const storedData = localStorage.getItem(key);
        if (storedData) {
          const parsedData = JSON.parse(storedData);
          
          // keyからitem_idを取得
          const itemId = key.split('imageData-')[1];
          parsedData.item_id = itemId;
  
          allImageData.push(parsedData);
          keysToRemove.push(key);
        }
      }
    }

    const tierId = this.getAttributeFromElement(document, "#tier-container", "data-tier-id");

    fetch(`/tiers/${tierId}/items/bulk_update_items`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.getCsrfToken()
        },
        body: JSON.stringify(allImageData)
    })
    .then(response => {
      if (response.ok) {
        for (const key of keysToRemove) {
          localStorage.removeItem(key);
        }
        window.location.href = response.url;
      } else {
        throw new Error('Network response was not ok');
      }
    })
    .catch(error => {
      console.error('There was a problem with the fetch operation:', error.message);
    });
  }

  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }
  getAttributeFromElement(element, selector, attribute) {
    return element.querySelector(selector).getAttribute(attribute);
  }
}
