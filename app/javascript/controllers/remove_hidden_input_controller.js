import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-hidden-input"
export default class extends Controller {
  connect() {
  }

  //style.display = "none"のinputを削除する
  removeHiddenInput() {
    const hiddenInputs = document.querySelectorAll("input[style='display: none;']");
    hiddenInputs.forEach((hiddenInput) => {
      hiddenInput.remove();
    });
  }
}
