function deleteUser(userId){
    let url = '/api/user/' + userId;
    r = new URLEncodedRequest(url, 'DELETE');
    r.send(function (xhr) {
        if(xhr.status == 200){
            let card = document.getElementById('userCard' + userId);
            card.remove();
        }
    });
}

function blockUser(userId){
    let url = '/api/user/' + userId + '/block';
    r = new URLEncodedRequest(url, 'PUT');
    let motive = document.getElementById('blockUser' + userId + 'ModalForm');
    r.setParam('block_motive', motive.content.value);
    r.send(function (xhr) {
        if(xhr.status == 200){
            let card = document.getElementById('userCard' + userId);
            card.classList.add('border-secondary');
            card.classList.add('border-1');
            let button = document.getElementById('blockButtonUser' + userId);
            button.innerHTML = 'Unblock';
            button.classList.add('btn-secondary');
            button.classList.remove('btn-outline-secondary');
            button.onclick = function () {unblockUser(userId)};
            button.removeAttribute('data-bs-toggle');
            button.removeAttribute('data-bs-target');
        }
    });
}

function unblockUser1(userId){
    let url = '/api/user/' + userId + '/unblock';
    r = new URLEncodedRequest(url, 'PUT');
    r.send(function (xhr) {
        if(xhr.status == 200){
            let card = document.getElementById('userCard' + userId);
            card.classList.remove('border-secondary');
            card.classList.remove('border-1');
            let button = document.getElementById('blockButtonUser' + userId);
            button.innerHTML = 'Block';
            button.classList.remove('btn-secondary');
            button.classList.add('btn-outline-secondary');
            button.removeAttribute('onclick');
            button.setAttribute('data-bs-toggle', 'modal');
            button.setAttribute('data-bs-target', '#blockUser' + userId + 'Modal');
        }
    });
}

function unblockUser2(userId) {
    let url = '/api/user/' + userId + '/unblock';
    r = new URLEncodedRequest(url, 'PUT');
    r.send(function (xhr) {
        if(xhr.status == 200){
            document.getElementById('unblockAppealUser' + userId).remove();
        }
    });
}