var Notifications = {
  onComplete: function(request, transport, json) {
    this.extractMessages(json);
  },
  onFailure: function(request, transport, json) {
    this.extractMessages(json);
  },
  extractMessages: function(json) {
    for (msgClass in json) {
         messages = typeof( json[msgClass] ) == 'string' ? new Array(json[msgClass]) : json[msgClass];
      for (var i = 0; i < messages.length; i++) {
        this.displayMessage(msgClass, msgClass, messages[i]);
      }
    }
  },
  displayMessage: function(klass, title, message) {
        html = '<div class="notification '+klass+' png_bg">';
        html += '<a onclick="$(this).parent().remove();" style="cursor: pointer;" class="close"><img src="/images/cross_grey_small.png" title="Close this notification" /></a>';
        html += '<div class=\'tehm\'>'+message+'</div>';
        html += '</div>';
        /*
        $(html).hover(function() {
            if($(this).hasClass("current_fade")) {
              $(this).stop(true, false).fadeTo('slow', 1.0).removeClass("current_fade");
              } 
            }, function() {
            if(!$(this).hasClass("current_fade")) {
              $(this).fadeOut(8000, function() { $(this).remove(); });
              $(this).addClass("current_fade");
            }
            }).appendTo("#notifications_container");
            */
        $(html).appendTo("#notifications_container");

        setTimeout("Notifications.fadeMessage()", 1500);
  },
  fadeMessage: function() {
   $('#notifications_container div.png_bg').each(function(index,msg) {
            if(!$(msg).hasClass("current_fade")) {
              $(msg).fadeOut(3800, function() { $(this).remove(); });
              $(msg).addClass("current_fade");
            }
     });
  }
};

$('#notifications_container').bind("ajaxComplete", function() {
   

});
