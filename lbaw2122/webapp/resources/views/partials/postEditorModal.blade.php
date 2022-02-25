<!-- Modal -->
<div class="modal fade" id="postEditor" tabindex="-1" role="dialog" aria-labelledby="postEditorLabel" aria-hidden="true">
<div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
    <div class="modal-content h-100">
        <div class="modal-header">
            <h5 class="modal-title" id="postEditorLabel">Post</h5>
        </div>
        <div class="modal-body" style="overflow-y:hidden">
            <div id="postEditorQuill">
            </div>
        </div>
        <div class="modal-footer">
            <button id="postEditorCreateButton" type="button" class="btn btn-primary" data-bs-dismiss="modal" onclick="createPost('{{ $event_id }}', @can('editPost', $event)true @else false @endcan, @can('deletePost', $event)true @else false @endcan)">Create</button>
            <button id="postEditorEditButton" type="button" class="btn btn-primary" data-bs-dismiss="modal" hidden='true'>Edit</button>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
    </div>
</div>
</div>