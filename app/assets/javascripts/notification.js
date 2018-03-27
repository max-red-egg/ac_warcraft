/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Notifications {
  constructor() {
    this.handleDropdownClose = this.handleDropdownClose.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.unreadClick = this.unreadClick.bind(this);
    this.handleSuccess = this.handleSuccess.bind(this);
    this.readAll = this.readAll.bind(this);
    this.notifications = $("[data-behavior='notifications']");

    if (this.notifications.length > 0) {
      this.handleSuccess(this.notifications.data("notifications"));
      $("[data-behavior='notifications-link']").on("click", this.handleClick);
      this.notifications.on("hide.bs.dropdown",this.handleDropdownClose);
      //$("[data-behavior='notifications-link']").on("click", this.handleClick);
      console.log("2");
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
    console.log('load');
    $.ajax({
      url: "/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: this.handleSuccess
    });
  }
  handleClick(e){
    $.ajax({
      url: "/notifications.json",
      dataType: "JSON",
      method: "GET",
      success: this.handleSuccess
    });
  }

  handleDropdownClose(e){
    $.ajax({
       url: "/notifications/mark_as_checked_all",
       dataType: "JSON",
       method: "POST",
       success() {
         $("[data-behavior='unchecked-count']").hide();
       }
     });

  }


  unreadClick(e){
    let id = e.delegateTarget.id;
    let href = e.delegateTarget.href;
    //console.log(e.delegateTarget.id);
    e.preventDefault();
    $.ajax({
      url: "/notifications/"+id+"/mark_as_read",
      dataType: "JSON",
      method: "POST",
      success() {
        window.location.href = href;
      }
    });
  }
  readAll(e){
    $.ajax({
      url: "/notifications/mark_as_read_all",
      dataType: "JSON",
      method: "POST",
      success() {
        $(".list-group-item").removeClass("unread-notification");
      }
    });
  }

  handleSuccess(data) {
    const items = $.map(data, notification => notification.template);
    console.log('handleSuccess');
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
    $("a[data-behavior='notification-item']").on("click",this.unreadClick);
    $("[data-behavior='notification-readall']").on("click",this.readAll);

  }
}

jQuery(() => new Notifications);