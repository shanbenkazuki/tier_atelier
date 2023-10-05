import html2canvas from 'html2canvas'

document.addEventListener("turbo:load", () => {
  const downloadBtn = document.getElementById("download-image-button");

  if (downloadBtn) {
    // ダウンロードボタンの動作
    downloadBtn.addEventListener('click', () => {
      html2canvas(document.querySelector("#tier-container"), { 
        useCORS: true 
      }).then(canvas => {
        const link = document.createElement('a');
        link.href = canvas.toDataURL("image/png");
        link.download = 'tier-container.png';
        link.click();
      });
    });
  }
});
