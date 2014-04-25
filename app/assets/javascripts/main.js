$(function() {
  $("#micropost_content").on("keydown", function() {
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
  });

  $(".media").on({
    mouseenter: function(){ $(this).find("a.hover-visiable").show(); },
    mouseleave: function(){ $(this).find("a.hover-visiable").hide(); }
  });

  $(".reply-button").on("click", function(){
    $("#micropost_content")
    .focus()
    .val("@" + $(this).data("name") + ": ")
    .trigger("keydown");
  });

  $(".show-micropost-modal").hide();
  if($("#new_micropost").length > 0){
    $(window).on("scroll", function(){
      var micropost_form = $("#new_micropost");
      var bottom_y = micropost_form.offset().top + micropost_form.height();

      if($(window).scrollTop() > bottom_y) {
        $(".show-micropost-modal").show();
      }
      else{
        $(".show-micropost-modal").hide();
      }
    });
  }
});