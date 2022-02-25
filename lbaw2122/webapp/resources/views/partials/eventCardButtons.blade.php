<a href="{{ url('/event/' . $event->id) }}" class="btn btn-secondary ml-auto">Event page</a>
@can('join', $event)
    <form id="joinEvent{{ $event->id }}Form" method="POST" style="display: inline;" action="{{ route('joinEvent', ['event_id' => $event->id]) }}">
    {{ csrf_field() }}
    <a onclick="document.getElementById('joinEvent{{ $event->id }}Form').submit();" class="btn btn-success ml-auto">Join event</a>
    </form>
@endcan
@can('request', $event)
    @if(is_null($event->requests()->where('user_id', Auth::id())->first()))
        <a id="request{{ $event->id }}" onclick="sendRequest('{{ $event->id }}')" class="btn btn-danger ml-auto">Request to join</a>
    @endif
@endcan