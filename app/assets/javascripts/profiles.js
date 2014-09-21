var lastConnId = "0";

function pollConnections() {
  $.ajax({
    dataType: "json",
    url: "/profile/new_changes",
    data: {last_seen: lastConnId},
    headers: {'X-SILENCE-LOGGER':'true'},
    success: function( data ) {
      if(data.status == 'new') {
        location.reload();
      }
      setTimeout(pollConnections, 500);
    }
  });
}

function startPolling(last) {
  lastConnId = last;
  setTimeout(pollConnections, 500);
}
