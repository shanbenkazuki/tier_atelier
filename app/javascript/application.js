// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import '@fortawesome/fontawesome-free'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { far } from '@fortawesome/free-regular-svg-icons'
import { fab } from '@fortawesome/free-brands-svg-icons'
import { library } from "@fortawesome/fontawesome-svg-core";
library.add(fas, far, fab)

import "./src/jquery"
import "./src/jquery-ui"

$(function() {
  $('.draggable').draggable({
    revert: 'invalid',
    helper: 'clone',
    appendTo: 'body'
  });

  $('.tier.cell').droppable({
    accept: '.draggable',
    drop: function(event, ui) {
      // 元の画像を削除
      ui.draggable.remove();
  
      // ドロップされた要素のクローンを作成
      var cloned = $(ui.helper).clone();
  
      // クローンの位置をリセット
      cloned.css({
        top: 0,
        left: 0,
        position: 'relative'
      });
  
      // クローンをドラッグ可能に設定
      cloned.draggable({
        revert: 'invalid',
        helper: 'clone',
        appendTo: 'body'
      });
  
      // クローンをドロップ先に追加
      $(this).append(cloned);
      var categoryIndex = $(this).index() - 1;
      var categoryId = $(".category-row .category-label").eq(categoryIndex).data('category-id');
      var rankId = $(this).siblings('.label-holder').data('rank-id');
      var tierId = window.location.pathname.split('/')[2];
      var imageUrl = $(ui.helper).attr('src');
      var imageId = $(ui.draggable).attr('id');
      var fileName = decodeURIComponent(imageUrl.split('/').pop());
      var uniqueImageUrl = imageUrl + (imageUrl.includes('?') ? '&' : '?') + 'timestamp=' + new Date().getTime();

      // URLからBlobデータを取得
      fetch(uniqueImageUrl)
        .then(response => response.blob())
        .then(blob => {
          var formData = new FormData();
          formData.append('image', blob, fileName);
          formData.append('category_id', categoryId);
          formData.append('rank_id', rankId);
          formData.append('image_id', imageId);
          formData.append('is_independent', false);
          // Ajaxリクエスト
          $.ajax({
            url: '/tiers/' + tierId + '/items',
            type: 'PUT',
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: function(xhr) {
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
            },
            error: function(jqXHR, textStatus, errorThrown) {
              console.error('Error:', textStatus, errorThrown);
              console.error('Response:', jqXHR.responseText);
            }
          });
        });
    }
  });  

  // containerをドロップ先として設定
  $('#independent-area').droppable({
    accept: '.draggable',
    drop: function(event, ui) {
      // 元の画像を削除
      ui.draggable.remove();

      // ドロップされた要素のクローンを作成
      var cloned = $(ui.helper).clone();

      // クローンの位置をリセット
      cloned.css({
        top: 0,
        left: 0,
        position: 'relative'
      });

      // クローンをドラッグ可能に設定
      cloned.draggable({
        revert: 'invalid',
        helper: 'clone',
        appendTo: 'body'
      });

      // クローンをドロップ先に追加
      $(this).append(cloned);
      var tierId = window.location.pathname.split('/')[2];
      var isIndependent = $(this).attr('id') == 'independent-area';
      var imageUrl = $(ui.helper).attr('src');
      var uniqueImageUrl = imageUrl + (imageUrl.includes('?') ? '&' : '?') + 'timestamp=' + new Date().getTime();
      var fileName = decodeURIComponent(imageUrl.split('/').pop());
      var imageId = $(ui.draggable).attr('id');

      // URLからBlobデータを取得
      fetch(uniqueImageUrl)
        .then(response => response.blob())
        .then(blob => {
          var formData = new FormData();
          formData.append('image', blob, fileName);
          formData.append('image_id', imageId);
          formData.append('is_independent', isIndependent);
          // Ajaxリクエスト
          $.ajax({
            url: '/tiers/' + tierId + '/items',
            type: 'PUT',
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: function(xhr) {
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
            },
            error: function(jqXHR, textStatus, errorThrown) {
              console.error('Error:', textStatus, errorThrown);
              console.error('Response:', jqXHR.responseText);
            }
          });
        });
    }
  });
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
      },
      "Close": function() {
        $(this).dialog("close");
      }
    }
  });

  $(document).on('click', '#open-modal', function() {
    $("#myModal").dialog("open");
  });
});
