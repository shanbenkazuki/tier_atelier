import { Controller } from "@hotwired/stimulus";
import html2canvas from 'html2canvas';

export default class extends Controller {
  displayTierImage() {
    html2canvas(document.querySelector("#tier-container"), {
      useCORS: true
    }).then(canvas => {
      const image = canvas.toDataURL("image/png");
      const blob = this.dataURLtoBlob(image);
      const url = window.URL.createObjectURL(blob);
      
      this.embedImageInModal(url);
    });
  }

  dataURLtoBlob(dataURL) {
    const binary = atob(dataURL.split(',')[1]);
    const array = [];
    for (let i = 0; i < binary.length; i++) {
      array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], { type: 'image/png' });
  }

  embedImageInModal(url) {
    const modalBody = document.querySelector(".modal-body");
  
    // 既存のimg要素を削除する
    const existingImg = modalBody.querySelector("img");
    if (existingImg) {
      existingImg.remove();
    }
  
    const imgElement = document.createElement("img");
    imgElement.src = url;
    imgElement.alt = "Captured Tier Image";
    imgElement.style.width = "100%";  // 幅をモーダルの幅に合わせる
    imgElement.style.height = "auto"; // アスペクト比を保持する
    
    modalBody.appendChild(imgElement);
  }
}
