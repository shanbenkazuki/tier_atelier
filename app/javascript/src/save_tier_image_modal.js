import html2canvas from 'html2canvas'

document.addEventListener("DOMContentLoaded", () => {
  const downloadBtn = document.getElementById("download-image-button");

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
});
