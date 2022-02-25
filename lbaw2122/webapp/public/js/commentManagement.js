function reloadComments(content) {
    let commentList = document.getElementById('commentsList');
    commentList.innerHTML = content;
}

function addComment(eventId) {
    let url = '/api/event/' + eventId + '/comment';
    let form = document.getElementById('comment-form');
    if(form == null){
        return;
    }

    let content = form.content.value;
    let files = form["files[]"].files;

    let request = new FormDataRequest(url);
    request.setParam('content', content);
    for(let file of files) request.setParam('files[]', file);
    request.send(function (xhr) {
        if(xhr.status == 200){
            reloadComments(xhr.response);
            document.getElementById("comment-form").reset();
        }
    }); 
}

function deleteComment(commentId) {
    let url = '/api/comment/' + commentId;
    let request = new URLEncodedRequest(url, 'DELETE');
    request.send(function (xhr) {
        if(xhr.status == 200) {
            document.getElementById('commentRow' + commentId).remove();
            let commentsList = document.getElementById('commentsList');
            if(commentsList.childElementCount == 0) {
                let msg = document.createElement('h3');
                msg.innerHTML = ' No comment has been created. ';
                commentsList.appendChild(msg);
            }
        }
    });
}

function isRatingSelected(elem) {
    return elem.classList.contains('bi-hand-thumbs-up-fill') || elem.classList.contains('bi-hand-thumbs-down-fill');
}

function updateRatingElement(icon, number, upvote) {
    let base = upvote ? 'bi-hand-thumbs-up' : 'bi-hand-thumbs-down';
    if (icon.classList.contains(base)) {
        icon.classList.remove(base);
        icon.classList.add(base + '-fill');
        number.innerText = parseInt(number.innerText) + 1;
    } else {
        icon.classList.remove(base + '-fill');
        icon.classList.add(base);
        number.innerText = parseInt(number.innerText) - 1;
    }
}

function addRatingComment(commentId, upvote) {
    let url = '/api/comment/' + commentId + '/rating';
    let request = new URLEncodedRequest(url, 'POST');
    request.setParam('rating', upvote);
    request.send(function (xhr) {
        if(xhr.status == 200) {
            let upIcon = document.getElementById('upvote' + commentId);
            let downIcon = document.getElementById('downvote' + commentId);
            let upNum = document.getElementById('upvotes' + commentId);
            let downNum = document.getElementById('downvotes' + commentId);

            let otherIcon = upvote ? downIcon : upIcon;
            let otherNum = upvote ? downNum : upNum;
            updateRatingElement(upvote ? upIcon : downIcon, upvote ? upNum : downNum, upvote);
            if (isRatingSelected(otherIcon)) updateRatingElement(otherIcon, otherNum, !upvote);
        }
    });
}