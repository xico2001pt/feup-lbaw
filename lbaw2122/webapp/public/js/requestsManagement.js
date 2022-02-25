function sendRequest(eventId) {
    let url = '/api/event/' + eventId + '/request';
    r = new URLEncodedRequest(url, 'POST');
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('request' + eventId).remove();
        } else if (xhr.status == 401){
            window.location = '/login';
        }
    });
}

function accept(requestId) {
    let url = '/api/request/' + requestId + '/accept';
    r = new URLEncodedRequest(url, 'PUT');
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('request' + requestId).remove();
        }
    });
}

function reject(requestId) {
    let url = '/api/request/' + requestId + '/reject';
    r = new URLEncodedRequest(url, 'DELETE');
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('request' + requestId).remove();
        }
    });
}