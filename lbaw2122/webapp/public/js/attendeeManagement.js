function kick(eventId,userId) {
    let url = '/api/event/' + eventId + '/kick';
    r = new URLEncodedRequest(url, 'DELETE');
    r.setParam('user_id',userId);
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('attendee' + userId).remove();
        }
    });
}

function invite(eventId) {
    let url = '/api/event/' + eventId + '/invite';
    let input_box = document.getElementById('invitedUsername');
    let feedback = document.getElementById('inviteFeedback');
    if(input_box == null){
        return;
    }
    let username = input_box.value;
    if(username != null){
        r = new URLEncodedRequest(url, 'POST');
        r.setParam('username', username);
        r.send(function (xhr) {
            if(xhr.status == 200){
                validInviteFeedback(input_box,feedback);
            } else if (xhr.status == 406){
                invalidInviteFeedback(input_box,feedback,'Invitation was already sent.');
            } else if (xhr.status == 409) {
                invalidInviteFeedback(input_box,feedback,'The invitee already belongs to the event.');
            } else {
                invalidInviteFeedback(input_box,feedback,'Invitation not sent.');
            }
        });
    }
}

function validInviteFeedback(input_box, feedback){
    input_box.classList.remove('is-invalid');
    feedback.classList.remove('invalid-feedback');
    input_box.classList.add('is-valid');
    feedback.classList.add('valid-feedback');
    feedback.innerHTML = 'Invitation sent.';
}

function invalidInviteFeedback(input_box, feedback, message){
    input_box.classList.remove('is-valid');
    input_box.classList.add('is-invalid');
    feedback.classList.remove('valid-feedback');
    feedback.classList.add('invalid-feedback');
    feedback.innerHTML = message;
}

function clearInviteFeedback(){
    let input_box = document.getElementById('invitedUsername');
    let feedback = document.getElementById('inviteFeedback');
    input_box.classList.remove('is-invalid');
    input_box.classList.remove('is-valid');
    feedback.classList.remove('invalid-feedback');
    feedback.classList.remove('valid-feedback');
    feedback.innerHTML = '';
}
