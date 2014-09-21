var lastConnId = "0";

function pollConnections() {
  $.getJSON("profile/new_changes", {last_seen: lastConnId}, function( data ) {
    if(data.status == 'new') {
      location.reload();
    }
    setTimeout(pollConnections, 500);
  });
}

function startPolling(last) {
  lastConnId = last;
  setTimeout(pollConnections, 500);
}
