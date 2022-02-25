// Send AJAX request to create post
function createPost(eventId, canEdit, canDelete) {
    let url = '/api/event/' + eventId + '/post';
    let contents = quill.getContents();
    let json = JSON.stringify(contents);
    r = new URLEncodedRequest(url, 'POST');
    r.setParam('text', json);
    r.send(function (xhr) {
        if(xhr.status == 200){
            refreshPosts(xhr.response);
        }
    });
}

// Send AJAX request to delete post
function deletePost(postId) {
    let url = '/api/post/' + postId;
    r = new URLEncodedRequest(url, 'DELETE');
    r.send(function (xhr) {
        if(xhr.status == 200) {
            document.getElementById('postRow' + postId).remove();
            let postList = document.getElementById('postList');
            if(postList.childElementCount == 0){
                let msg = document.createElement('h3');
                msg.innerHTML = ' No post has been created. ';
                postList.appendChild(msg);
            }
        }
    });
}

// Send AJAX request to edit post
function editPost(postId) {
    let url = '/api/post/' + postId;
    let newHTMLContent = quill.root.innerHTML;
    let contents = quill.getContents();
    let json = JSON.stringify(contents);
    r = new URLEncodedRequest(url, 'PUT');
    r.setParam('text', json);
    r.send(function (xhr) {
        if(xhr.status == 200){
            let post = document.getElementById('post' + postId);
            post.innerHTML = newHTMLContent;
            post.setAttribute('delta', contents);
        }
    });
}

function refreshPosts(content){
    let postList = document.getElementById('postList');
    postList.innerHTML = content;
    loadPosts();
}

// Prepare editor for Create operopenPostEation
function openPostEditorForCreate(eventId){
    document.getElementById('postEditorCreateButton').hidden = false;
    document.getElementById('postEditorEditButton').hidden = true;
    clearPostEditor();
}

// Prepare editor for Update operation
function openPostEditorForEdit(postId){
    document.getElementById('postEditorCreateButton').hidden = true;
    let editButton = document.getElementById('postEditorEditButton');
    editButton.hidden = false;
    editButton.onclick = () => { editPost(postId) };
    let post = document.getElementById('post' + postId);
    let postDelta = post.getAttribute('delta');
    quill.setContents(JSON.parse(postDelta), 'api');
}

// Load a post content to HTML
function loadPost(post){
    console.log("Loading a post");
    let postDelta = post.getAttribute('delta');
    quill.setContents(JSON.parse(postDelta), 'api');
    post.innerHTML = quill.root.innerHTML;
}

// Load all posts to HTML
function loadPosts(){
    for(let post of document.getElementsByClassName("postText")){
        loadPost(post);
    }
}

// Clear Quill editor
function clearPostEditor(){
    quill.deleteText(0,quill.getLength());
}

var quill = new Quill('#postEditorQuill', {
    modules: {
      toolbar: [
        [{ header: [1, 2, false] }],
        ['bold', 'italic', 'underline'],
        ['blockquote', 'code-block'],
      ]
    },
    placeholder: 'Compose your post...',
    theme: 'snow'
  });

loadPosts();