<div class="modal fade" id="blockUser{{ $user->id }}Modal" tabindex="-1" role="dialog" aria-labelledby="blockUser{{ $user->id }}Label" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="blockUser{{ $user->id }}Label">Input Block Reason for {{ $user->username }}</h5>
        </div>
        <div class="modal-body">
            <form id="blockUser{{ $user->id }}ModalForm" class="my-1">
                <textarea maxlength="200" type="textarea" name="content" class="form-control" required></textarea>
            </form>
            <a type="button" class="btn btn-success my-1" onclick="blockUser({{ $user->id }})" data-bs-dismiss="modal">Block</a>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
        </div>
    </div>
</div>