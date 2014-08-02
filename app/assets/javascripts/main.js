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

  var li_show_modal = $(".show-micropost-modal");
  li_show_modal.hide();

  var micropost_form_container = $("#micropost_form_container");
  var micropost_form = micropost_form_container.children("#new_micropost");

  if(micropost_form.length > 0) {
    var bottom_y = micropost_form.offset().top + micropost_form.height();
    $(window).on("scroll", function() {

      if($(window).scrollTop() > bottom_y) {
        micropost_form.remove();
        li_show_modal.show();
      }
      else {
        micropost_form_container.append(micropost_form);
        li_show_modal.hide();
      }
    });
  }

  $(".reply-button").on("click", function() {
    $("#micropost_content")
    .focus()
    .val("@" + $(this).data("name") + ": ")
    .trigger("keydown");

    $("#micropost_in_reply_to").val($(this).data("id"));

    if(micropost_form_container.children().length == 0) {
      li_show_modal.children("a").click();
    }
  });
});