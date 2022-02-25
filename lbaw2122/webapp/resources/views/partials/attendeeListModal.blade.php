<!-- Modal -->
<div class="modal fade" id="attendees" tabindex="-1" role="dialog" aria-labelledby="attendeesLabel" aria-hidden="true">
<div class="modal-dialog modal-dialog-scrollable" role="document">
    <div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title" id="attendeesLabel">Attendees</h5>
    </div>
    <div class="modal-body">
        <div class="wrapper container">
        @forelse($event->attendees()->get() as $user)
            <div class="flex-row justify-content-between d-flex" id="attendee{{ $user->id }}">
                <div class="p-2">
                    <img class="img-fluid rounded-circle mx-2" style="height:4em;" src="{{ route('userImage', ['user_id' => $user->id]) }}">
                    <a>{{ $user->username }}</a>
                </div>
                @can('update', $event)
                <div class="p-2 my-auto">
                <button onclick="kick({{$event->id}}, {{$user->id}})" class="btn btn-outline-danger">Kick</button>
                </div>
                @endcan
            </div>
        @empty
            <h4>The attendee's list is still empty.</h4>
        @endforelse
        </div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
    </div>
    </div>
</div>
</div>