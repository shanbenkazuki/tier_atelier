import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"];

  connect() {
    this.element.addEventListener("direct-upload:initialize", this.initializeUpload.bind(this));
    this.element.addEventListener("direct-upload:start", this.startUpload.bind(this));
    this.element.addEventListener("direct-upload:progress", this.progressUpdate.bind(this));
    this.element.addEventListener("direct-upload:error", this.handleError.bind(this));
    this.element.addEventListener("direct-upload:end", this.endUpload.bind(this));
  }

  previewImage() {
    const images = this.inputTarget.files;

    this.clearPreview();

    Array.from(images).forEach(image => {
      const reader = new FileReader();

      reader.onload = (e) => {
        const img = document.createElement('img');
        img.src = e.target.result;
        img.style.width = '80px';
        img.style.height = 'auto';
        this.previewTarget.appendChild(img);
      };

      reader.readAsDataURL(image);
    });
  }

  clearPreview() {
    while (this.previewTarget.firstChild) {
      this.previewTarget.removeChild(this.previewTarget.firstChild);
    }
  }

  initializeUpload(event) {
    const { target, detail } = event;
    const { id, file } = detail;
    target.insertAdjacentHTML("beforebegin", `
      <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
        <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
        <span class="direct-upload__filename">${file.name}</span>
      </div>
    `);
  }

  startUpload(event) {
    const { id } = event.detail;
    const element = document.getElementById(`direct-upload-${id}`);
    element.classList.remove("direct-upload--pending");
  }

  progressUpdate(event) {
    const { id, progress } = event.detail;
    const progressElement = document.getElementById(`direct-upload-progress-${id}`);
    progressElement.style.width = `${progress}%`;
  }

  handleError(event) {
    event.preventDefault();
    const { id, error } = event.detail;
    const element = document.getElementById(`direct-upload-${id}`);
    element.classList.add("direct-upload--error");
    element.setAttribute("title", error);
  }

  endUpload(event) {
    const { id } = event.detail;
    const element = document.getElementById(`direct-upload-${id}`);
    element.classList.add("direct-upload--complete");
  }

  disconnect() {
    this.element.removeEventListener("direct-upload:initialize", this.initializeUpload.bind(this));
    this.element.removeEventListener("direct-upload:start", this.startUpload.bind(this));
    this.element.removeEventListener("direct-upload:progress", this.progressUpdate.bind(this));
    this.element.removeEventListener("direct-upload:error", this.handleError.bind(this));
    this.element.removeEventListener("direct-upload:end", this.endUpload.bind(this));
  }
}
