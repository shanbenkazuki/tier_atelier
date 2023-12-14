import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    this.element.querySelectorAll('.toast').forEach(toastNode => {
      let toast = new Toast(toastNode);
      toast.show();
    });
  }
}