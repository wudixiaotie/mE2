$(function() {
  $("textarea.content").on("keyup", function() {
    var remaining = 140 - $(this).val().length;
    var text;

    if(remaining < 0) {
      if(remaining == -1) {
        text = "exceed " + Math.abs(remaining) + " character remaining";
      }
      else {
        text = "exceed " + Math.abs(remaining) + " characters remaining";
      }
    }
    else {
      if(remaining == 0 || remaining == 1) {
        text = remaining + " character remaining";
      }
      else {
        text = remaining + " characters remaining";
      }
    }

    $(this).siblings(".remaining").text(text);
  })
})