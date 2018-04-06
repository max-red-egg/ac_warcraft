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
// });
