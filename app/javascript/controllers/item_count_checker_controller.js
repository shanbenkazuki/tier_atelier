import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["file"];

  checkFileCount() {
    const files = this.fileTarget.files;
    if (files.length > 30) {
      alert("画像は30枚までしかアップロードできません。");
      this.fileTarget.value = '';
    } else if (files.length < 5) {
      alert("画像は5枚以上アップロードしてください。");
    }
  }
}
