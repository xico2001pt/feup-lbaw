<!-- Modal -->
<div class="modal fade" id="invites" tabindex="-1" role="dialog" aria-labelledby="invitesLabel" aria-hidden="true">
<div class="modal-dialog modal-dialog-scrollable" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title" id="invitesLabel">Invites</h5>
    </div>
    <div class="modal-body">
        <div class="wrapper container">
        @forelse($user->invites()->get() as $invite)
            @if(!$invite->accepted)
                <div class="row my-2" id="invite{{ $invite->id }}">
                    <div class="col-8 d-flex align-self-center">
                        <span>{{ $invite->inviter()->first()->username }} invites you to&nbsp;</span>
                        <a href="{{ url('/event/' . $invite->event()->first()->id) }}">{{ $invite->event()->first()->title }}</a>
                    </div>
                    <div class="col d-flex justify-content-end">
                        <button onclick="accept({{$invite->id}})" class="btn btn-outline-success mx-1">
                        @if($invite->event()->first()->is_accessible)
                        Accept
                        @else
                        Request
                        @endif
                        </button>
                        <button onclick="reject({{$invite->id}})" class="btn btn-outline-danger mx-1">Reject</button>
                    </div>
                </div>
            @endif
        @empty
            <h4>Currently you have no invites.</h4>
        @endforelse
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>