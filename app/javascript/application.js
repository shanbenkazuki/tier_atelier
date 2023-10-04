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

ActiveStorage.start()

$(function() {
  var categoryCounter = 5;
  var rankCounter = 5;
  var maxFields = 10; // 例として、最大10個のフィールドを設定
  
  $(document).on('click', '#add-category', function() {
    if(categoryCounter < maxFields){
      categoryCounter++;
      var newTextField = "<input class='form-control mt-2' type='text' name='tier[category_" + categoryCounter + "]' id='tier_category_" + categoryCounter + "'>";
      $(newTextField).insertBefore("#add-category");
      $('#tier_category_column_num').val(categoryCounter);
    } else {
      alert('最大カテゴリ数に達しました');
    }
  });

  $(document).on('click', '#remove-category', function() {
    if(categoryCounter > 5){
      $("#tier_category_" + categoryCounter).remove();
      categoryCounter--;
      $('#tier_category_column_num').val(categoryCounter);
    } else {
      alert('これ以上フィールドを削除できません');
    }
  });

  $(document).on('click', '#add-rank', function() {
    if(rankCounter < maxFields){
      rankCounter++;
      var newTextField = "<input class='form-control mt-2' type='text' name='tier[rank_" + rankCounter + "]' id='tier_rank_" + rankCounter + "'>";
      $(newTextField).insertBefore("#add-rank");
      $('#tier_rank_column_num').val(rankCounter);
    } else {
      alert('最大ランク数に達しました');
    }
  });

  $(document).on('click', '#remove-rank', function() {
    if(rankCounter > 5){
      $("#tier_rank_" + rankCounter).remove();
      rankCounter--;
      $('#tier_rank_column_num').val(rankCounter);
    } else {
      alert('これ以上フィールドを削除できません');
    }
  });

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
