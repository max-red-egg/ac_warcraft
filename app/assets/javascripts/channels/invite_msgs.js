// $(document).ready( function() {
function startInviteMsgs(){
  //console.log('loading invite_msgs.js')
  let msgs_board = $("#invitation_msg");


  if( msgs_board.length > 0 ) {
    //console.log("action cable invite_msgs: start sub invite_msgs board: " + msgs_board.data('invitation-id'));
    

    App.notifications = App.cable.subscriptions.create({
      channel: "InviteMsgsChannel",
      invitation_id: msgs_board.data('invitation-id')} ,{
        connected: function() {
          // Called when the subscription is ready for use on the server
            console.log('action cable connected');
        },

        disconnected: function() {
          // Called when the subscription has been terminated by the server
        },

        received: function(data) {
          // Called when there's incoming data on the websocket for this channel
          //console.log('action cable received '+data.message);
          $.ajax({
            url: "/invite_msgs/"+ data.message ,
            dataType: "html",
            method: "GET",
            success: (data)=>{
              //console.log(data);
              msgs_board.append(data);
              

            }
          });
        }
      }
    );
  }
}

function readInviteMsgs(id){
  //將訊息設定為已讀
  //把未讀數字消除
  let sidebar_nav_badge = $("#invitation_badge");
  let invite_nav_badge = $(".invite_msg_nav.active .badge-danger");
  let invite_count_tag = $("#unread_"+id);
  $.ajax({
    url: "/invitations/"+ id+"/read_all_msg",
    dataType: "html",
    method: "POST",
    success: (data)=>{
      console.log("#unread_"+id);
      if (invite_count_tag.length > 0 && sidebar_nav_badge.length>0 && invite_nav_badge.length>0){
        let msg_count = parseInt(invite_count_tag.text());
        let sidebar_badge_num = parseInt(sidebar_nav_badge.text());
        let invite_nav_badge_num = parseInt(invite_nav_badge.text());
        if(sidebar_badge_num - msg_count == 0){
          sidebar_nav_badge.text(0);
          sidebar_nav_badge.hide();
        }else{
          sidebar_nav_badge.text(sidebar_badge_num - msg_count);
        }
        if(invite_nav_badge_num - msg_count == 0){
          invite_nav_badge.text(0);
          invite_nav_badge.hide();
        }else{
          invite_nav_badge.text(invite_nav_badge_num - msg_count);
        }
        invite_count_tag.text(0);
        invite_count_tag.hide();
      }
    }
  });
}
// });
