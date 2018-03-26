/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Notifications {
  constructor() {
    this.handleClick = this.handleClick.bind(this);
    this.handleSuccess = this.handleSuccess.bind(this);
    this.notifications = $("[data-behavior='notifications']");

    if (this.notifications.length > 0) {
      this.handleSuccess(this.notifications.data("notifications"));
      
      $("[data-behavior='notifications-link']").on("click", this.handleClick);

      this.getNewNotifications();
      // setInterval((() => {
      //   console.log("getNotifications!!");
      //   return this.getNewNotifications();
      // }
      // ), 5000);
      // 五秒讀一次
    }
  }

  getNewNotifications() {
    return $.ajax({
      url: "/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: this.handleSuccess
    });
  }

  handleClick(e) {
    console.log('handleClick');
    return $.ajax({
      url: "/notifications/mark_as_read",
      dataType: "JSON",
      method: "POST",
      success() {
        $("[data-behavior='unread-count']").hide();
      }
    });
  }

  handleSuccess(data) {
    const items = $.map(data, notification => notification.template);
    console.log(items);
    let unread_count = 0;
    $.each(data, function(i, notification) {
      if (notification.unread) {
        return unread_count += 1;
      }
    });
    console.log(unread_count)
    unread_count === 0 ? $("[data-behavior='unread-count']").hide() : $("[data-behavior='unread-count']").show()
    $("[data-behavior='unread-count']").text(unread_count);
    $("[data-behavior='notification-items']").html(items);
  }
}

jQuery(() => new Notifications);