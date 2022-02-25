<div class="row my-5 border" id="postRow{{$post->id}}">
    <p class="postText" id="post{{$post->id}}" delta='{{$post->text}}'></p>
    <p>{{$post->creation_date}}</p>
    <div>
        @can('editPost', $event)
        <a class="btn btn-outline-primary" type="button" data-bs-toggle="modal" href="#postEditor" onclick="openPostEditorForEdit('{{ $post->id }}')">Edit</a>
        @endcan
        @can('deletePost', $event)
        <a class="btn btn-outline-danger" type="button" onclick="deletePost('{{ $post->id }}')">Delete</a>
        @endcan
    </div>
</div>