import { Controller } from "@hotwired/stimulus"
import * as bootstrap from 'bootstrap';

export default class extends Controller {
  connect() {
    new bootstrap.Tooltip(this.element, {
      title: this.element.getAttribute("data-tooltip"),
      placement: 'top',
      trigger: 'hover focus'
    });
  }
}
