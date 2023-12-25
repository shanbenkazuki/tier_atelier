import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"

export default class extends Controller {
  connect() {
    new Tooltip(this.element, {
      title: this.element.getAttribute("data-tooltip")
    });
  }
}
