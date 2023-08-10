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
    }
  });  

  // containerをドロップ先として設定
  $('.container').droppable({
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
    }
  });
  
});


