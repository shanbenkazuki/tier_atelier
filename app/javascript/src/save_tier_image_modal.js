import html2canvas from 'html2canvas';

function handleDownloadClick() {
  html2canvas(document.querySelector("#tier-container"), {
    useCORS: true
  }).then(canvas => {
    const link = document.createElement('a');
    link.href = canvas.toDataURL("image/png");
    link.download = 'tier-container.png';
    link.click();
  });
}

function setupDownloadListener() {
  const downloadBtn = document.getElementById("download-image-button");

  if (downloadBtn) {
    // 既存のイベントリスナーを削除
    downloadBtn.removeEventListener('click', handleDownloadClick);
    // イベントリスナーを再度追加
    downloadBtn.addEventListener('click', handleDownloadClick);
  }
}

document.addEventListener("turbo:load", setupDownloadListener);
