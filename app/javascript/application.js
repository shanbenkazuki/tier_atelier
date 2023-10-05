// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import * as ActiveStorage from "@rails/activestorage"
import html2canvas from 'html2canvas'
import '@fortawesome/fontawesome-free'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { far } from '@fortawesome/free-regular-svg-icons'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { library } from "@fortawesome/fontawesome-svg-core";
library.add(fas, far, fab)

import "./src/jquery"
import "./src/jquery-ui"
import "./src/direct_uploads"
import "./src/tier_item_updater"
import "./src/dynamic_field"

ActiveStorage.start()

$(function() {
  $("#myModal").dialog({
    autoOpen: false,
    modal: true,
    buttons: {
      "ダウンロード": function() {
        html2canvas(document.querySelector("#tier-container"), { 
          useCORS: true 
        }).then(canvas => {
          var link = document.createElement('a');
          link.href = canvas.toDataURL("image/png");
          link.download = 'tier-container.png';
          link.click();
        });
      },
      "Close": function() {
        $(this).dialog("close");
      }
    }
  });

  $(document).on('click', '#open-modal', function() {
    $("#myModal").dialog("open");
  });

  $(document).on('change', '#image-upload', function() {
    let numberOfFiles = $(this)[0].files.length;
    if (numberOfFiles > 30) {
      alert('画像は30枚以下にしてください');
      $(this).val('');
    }
  });

  showUploadedImagePreview('#image-upload');
  showUploadedImagePreview('#cover-image-upload');

  function showUploadedImagePreview(inputSelector) {
    $(document).on('change', inputSelector, function() {
      let images = this.files;
      let previewArea = $(this).next('.image-preview');
      previewArea.empty();
  
      $.each(images, function(index, image) {
        let reader = new FileReader();
  
        reader.onload = function(e) {
          let img = $('<img>').attr('src', e.target.result).css({width: '80px', height: 'auto'});
          previewArea.append(img);
        };
  
        reader.readAsDataURL(image);
      });
    });
  }
});
