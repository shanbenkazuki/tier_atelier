import { Controller } from "@hotwired/stimulus"
import html2canvas from 'html2canvas';

export default class extends Controller {
  updateTierImage() {
    const allImageData = this.collectImageDataFromLocalStorage();
    const tierId = this.getAttributeFromElement(document, "#tier-container", "data-tier-id");

    this.updateBulkItems(allImageData, tierId);
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

  updateBulkItems(imageData, tierId) {
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
    window.location.href = `/tiers/${tierId}`;
  }

  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }
  getAttributeFromElement(element, selector, attribute) {
    return element.querySelector(selector).getAttribute(attribute);
  }

  // TODO: 本リリース後のアップデートで実装
  // updateTierCoverImage(tierId) {
  //   html2canvas(document.querySelector("#tier-container"), {
  //     useCORS: true
  //   })
  //   .then(canvas => {
  //     const image = canvas.toDataURL("image/png");
  //     const blob = this.dataURLtoBlob(image);

  //     const formData = new FormData();
  //     formData.append('image', blob);
  
  //     fetch(`/tiers/${tierId}/update_tier_cover_image`, {
  //       method: 'POST',
  //       headers: {
  //         'X-Requested-With': 'XMLHttpRequest',
  //         'X-CSRF-Token': this.getCsrfToken()
  //       },
  //       body: formData
  //     })
  //     .then(response => {
  //       if (response.ok) {
  //         this.redirectToTierPage(tierId);
  //       } else {
  //         throw new Error('Network response was not ok');
  //       }
  //     })
  //     .then(data => {
  //     })
  //     .catch(error => {
  //         console.error('Error uploading image:', error);
  //     });
      
  //   });
  // }

  dataURLtoBlob(dataURL) {
    const binary = atob(dataURL.split(',')[1]);
    const array = [];
    for (let i = 0; i < binary.length; i++) {
      array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], { type: 'image/png' });
  }
}
