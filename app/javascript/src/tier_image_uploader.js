document.addEventListener('turbo:load', () => {

  // 画像アップロード制限のリスナー
  const imageUploadElem = document.querySelector('#image-upload');
  imageUploadElem?.addEventListener('change', function() {
      let numberOfFiles = this.files.length;
      if (numberOfFiles > 30) {
          alert('画像は30枚以下にしてください');
          this.value = '';
      }
  });

  showUploadedImagePreview('#image-upload');
  showUploadedImagePreview('#cover-image-upload');

});

function showUploadedImagePreview(inputSelector) {
  const inputElement = document.querySelector(inputSelector);
  inputElement?.addEventListener('change', function() {
      const images = this.files;
      const previewArea = this.nextElementSibling;

      if (previewArea && previewArea.classList.contains('image-preview')) {
          while (previewArea.firstChild) {
              previewArea.removeChild(previewArea.firstChild);
          }

          Array.from(images).forEach(image => {
              const reader = new FileReader();

              reader.onload = function(e) {
                  const img = document.createElement('img');
                  img.src = e.target.result;
                  img.style.width = '80px';
                  img.style.height = 'auto';
                  previewArea.appendChild(img);
              };

              reader.readAsDataURL(image);
          });
      }
  });
}