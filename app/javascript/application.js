// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./src/jquery"
import "./src/jquery-ui"

$(function() {
  $('.draggable').draggable({
    revert: "invalid",
    start: function(event, ui) {
      $(this).data('originalPosition', $(this).position());
    }
  });
  
  $('#dropzone').droppable({
    accept: '.draggable',
    drop: function(event, ui) {
      ui.draggable.css(ui.draggable.data('originalPosition'));
      $(this).append(ui.draggable);
    }
  });
});
