function handleImageUploadChange() {
    let numberOfFiles = this.files.length;
    if (numberOfFiles > 30) {
        alert('画像は30枚以下にしてください');
        this.value = '';
    }
}

function handleUploadedImagePreviewChange() {
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
}

function setupListeners() {
    const imageUploadElem = document.querySelector('#image-upload');

    if (imageUploadElem) {
        // 既存のイベントリスナーを削除
        imageUploadElem.removeEventListener('change', handleImageUploadChange);
        // イベントリスナーを再度追加
        imageUploadElem.addEventListener('change', handleImageUploadChange);
    }

    setupImagePreviewListener('#image-upload');
    setupImagePreviewListener('#cover-image-upload');
}

function setupImagePreviewListener(selector) {
    const inputElement = document.querySelector(selector);

    if (inputElement) {
        // 既存のイベントリスナーを削除
        inputElement.removeEventListener('change', handleUploadedImagePreviewChange);
        // イベントリスナーを再度追加
        inputElement.addEventListener('change', handleUploadedImagePreviewChange);
    }
}

document.addEventListener('turbo:load', setupListeners);
