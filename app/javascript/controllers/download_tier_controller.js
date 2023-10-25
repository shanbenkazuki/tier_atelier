import { Controller } from "@hotwired/stimulus"
import html2canvas from 'html2canvas';

export default class extends Controller {
  downloadImage() {
    html2canvas(document.querySelector("#tier-container"), {
      useCORS: true
    }).then(canvas => {
      const image = canvas.toDataURL("image/png");
      const blob = this.dataURLtoBlob(image);
      const url = window.URL.createObjectURL(blob);
    
      const link = document.createElement('a');
      link.href = url;
      link.download = 'my-image.png';
      link.click();
    
      window.URL.revokeObjectURL(url);
    });
  }
  dataURLtoBlob(dataURL) {
    const byteString = atob(dataURL.split(',')[1]);
    const mimeString = dataURL.split(',')[0].split(':')[1].split(';')[0];
    const ab = new ArrayBuffer(byteString.length);
    const ia = new Uint8Array(ab);
  
    for (let i = 0; i < byteString.length; i++) {
      ia[i] = byteString.charCodeAt(i);
    }
    return new Blob([ab], { type: mimeString });
  }
}
