<!-- Modal -->
<div class="modal fade" id="requests" tabindex="-1" role="dialog" aria-labelledby="requestsLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="requestsLabel">Requests</h5>
        </div>
        <div class="modal-body">
            <div class="wrapper container">
            @foreach($requests as $request)
                <div class="row my-2" id="request{{ $request->id }}">
                    <div class="col-8 d-flex align-self-center">
                    <span>{{ $request->requester()->first()->username }}</span>
                    </div>
                    <div class="col d-flex justify-content-end">
                        <button onclick="accept({{ $request->id }})" class="btn btn-outline-success mx-1">Accept</button>
                        <button onclick="reject({{ $request->id }})" class="btn btn-outline-danger mx-1">Reject</button>
                    </div>
                </div>
            @endforeach
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
        </div>
    </div>
</div>