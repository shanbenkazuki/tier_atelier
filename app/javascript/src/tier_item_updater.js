document.addEventListener("turbo:load", function() {

  function getAttributeFromElement(element, selector, attribute) {
    return element.querySelector(selector).getAttribute(attribute);
  }

  function getTierCategoryId(cell) {
    const cellIndex = Array.from(cell.parentElement.children).indexOf(cell);
    const categoryRow = cell.parentElement.parentElement.querySelector(".category-row");
    const categoryLabel = categoryRow.children[cellIndex];
    return categoryLabel.getAttribute("data-category-id");
  }

  function fetchUpdateItem(tierId, categoryId, rankId, itemId) {
    fetch(`/tiers/${tierId}/items`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': getCsrfToken()
      },
      body: JSON.stringify({
        category_id: categoryId,
        rank_id: rankId,
        image_id: itemId
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

  function handleDrop(e, element) {
    e.preventDefault();
    const itemId = e.dataTransfer.getData("text");
    const draggedElem = document.getElementById(itemId);
    element.appendChild(draggedElem);

    const tierId = getAttributeFromElement(document, "#tier-container", "data-tier-id");
    let categoryId, rankId;

    if (element.id === 'default-area') {
      categoryId = getAttributeFromElement(document, "#default-area", "data-default-category-id");
      rankId = getAttributeFromElement(document, "#default-area", "data-default-rank-id");
    } else {
      categoryId = getTierCategoryId(element);
      rankId = getAttributeFromElement(element.parentElement, ".label-holder", "data-rank-id");
    }

    fetchUpdateItem(tierId, categoryId, rankId, itemId);
  }

  function getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  }

  document.querySelectorAll(".tier.cell, #default-area").forEach(cell => {
    cell.addEventListener("dragover", e => e.preventDefault());
    cell.addEventListener("drop", e => handleDrop(e, cell));
  });

  document.querySelectorAll("img[draggable]").forEach(img => {
    img.addEventListener("dragstart", e => {
      e.dataTransfer.setData("text", img.id);
    });
  });
});