<div class="modal fade" id="sendUnblockAppealModal" tabindex="-1" role="dialog" aria-labelledby="sendUnblockAppealLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="sendUnblockAppealLabel">Send Unblock Appeal</h5>
        </div>
        <div class="modal-body">
            <form id="unblockAppealForm" class="my-1">
                <textarea maxlength="200" type="textarea" name="content" class="form-control" required></textarea>
            </form>
            <a type="button" class="btn btn-success my-1" onclick="sendUnblockAppeal()" data-bs-dismiss="modal">Send</a>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
        </div>
    </div>
</div>