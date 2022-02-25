function sendUnblockAppeal() {
    let url = '/api/unblockAppeal';
    let form = document.getElementById('unblockAppealForm');
    if (form == null) {
        return;
    }

    let content = form.content.value;

    let request = new FormDataRequest(url);
    request.setParam('content', content);
    request.send(function (xhr) {
        if(xhr.status == 200){
            let button = document.getElementById('unblockAppealModalButton');
            button.removeAttribute('data-bs-toggle');
            button.removeAttribute('href');
            button.setAttribute('class', 'btn btn-success my-2');
            button.innerHTML = 'Unblock Appeal Sent';
            document.getElementById('sendUnblockAppealModal').remove();
        }
    });
}