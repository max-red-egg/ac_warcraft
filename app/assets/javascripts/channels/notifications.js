App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
    // console.log('load notification action');
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('action cable');
    $.ajax({
      url: "/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: (data)=>{
          const items = $.map(data, notification => notification.template);
          console.log('action cable ajax');
          let unchecked_count = 0;
          $.each(data, function(i, notification) {
            if (notification.unchecked) {
              return unchecked_count += 1;
            }
          });
          //console.log(unchecked_count)
          unchecked_count === 0 ? $("[data-behavior='unchecked-count']").hide() : $("[data-behavior='unchecked-count']").show()
          $("[data-behavior='unchecked-count']").text(unchecked_count);
          $("[data-behavior='notification-items'] > .notification-items-block").html(items);
          }
      })
    }
});

