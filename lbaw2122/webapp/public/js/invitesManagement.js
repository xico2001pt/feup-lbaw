function accept(inviteId) {
    let url = '/api/invite/' + inviteId + '/accept';
    r = new URLEncodedRequest(url, 'PUT');
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('invite' + inviteId).remove();
        }
    });
}

function reject(inviteId) {
    let url = '/api/invite/' + inviteId + '/reject';
    r = new URLEncodedRequest(url, 'DELETE');
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('invite' + inviteId).remove();
        }
    });
}