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
import "./src/tier_image_uploader"

ActiveStorage.start()

document.addEventListener("DOMContentLoaded", function() {
  var modal = document.getElementById("myModal");
  var btn = document.getElementById("openModal");
  var span = document.getElementById("closeModal");

  // ボタンクリックでモーダルを開く
  btn.onclick = function() {
    modal.style.display = "block";
  }

  // × マークをクリックでモーダルを閉じる
  span.onclick = function() {
    modal.style.display = "none";
  }

  // モーダルの外側をクリックでモーダルを閉じる
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
});


$(function() {
  // $("#myModal").dialog({
  //   autoOpen: false,
  //   modal: true,
  //   buttons: {
  //     "ダウンロード": function() {
  //       html2canvas(document.querySelector("#tier-container"), { 
  //         useCORS: true 
  //       }).then(canvas => {
  //         var link = document.createElement('a');
  //         link.href = canvas.toDataURL("image/png");
  //         link.download = 'tier-container.png';
  //         link.click();
  //       });
  //     },
  //     "Close": function() {
  //       $(this).dialog("close");
  //     }
  //   }
  // });
});
