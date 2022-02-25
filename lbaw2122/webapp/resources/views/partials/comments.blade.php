<h2 class="display-4">Comments</h2>
<form id="comment-form" class="form-group mb-3">
    <h1>Add comment:</h1>
    <textarea maxlength="200" type="textarea" name="content" class="form-control @if($errors->has('content')) is-invalid @endif" required></textarea>
    @if ($errors->has('content'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('content') }}
        </div>
    @endif
    <input class="form-control" type="file" name="files[]" multiple>
    <h6>Max 10 files, 500KB each. Allowed extensions: jpeg,png,jpg,gif,svg,pdf,txt</h6>
</form>
@can('createComment', $event)
    <a type="button" class="btn btn-secondary mb-5" onclick="addComment('{{ $event->id }}');">Publish</a>
@endcan
<div id="commentsList">
@section('comments')
    @forelse($comments as $comment)
        @include('partials.comment', ['comment' => $comment, 'event' => $event])
    @empty
        <h3> No comment has been created. </h3>
    @endforelse
@show
</div>