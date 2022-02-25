<!-- Modal -->
<div class="modal fade" id="inviteUser" tabindex="-1" role="dialog" aria-labelledby="inviteUserLabel" aria-hidden="true">
<div class="modal-dialog modal-dialog-scrollable" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title" id="inviteUserLabel">Invite user</h5>
    </div>
    <div class="modal-body">
        <div class="wrapper container">
            <form>
                <div class="form-group row">
                    <label class="col-sm-2 col-form-label" for="invitedUsername">Username</label>
                    <div class="col-sm-10">
                        <input class="form-control" type="text" id="invitedUsername"></input>
                        <div class="d-block" id="inviteFeedback">
                        </div>
                    </div>
                </div>
            </form>
            <button class="btn btn-outline-primary" onclick="invite({{$event->id}})">Invite</button>
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>