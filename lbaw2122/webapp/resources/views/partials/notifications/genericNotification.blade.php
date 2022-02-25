{{ $text }} <strong>{{ $strong ?? "" }}</strong>.
@if($includeEventButton)
<div class="mt-2 pt-2 border-top">
    <a href="{{ url('/event/' . $event_id) }}" class="btn btn-secondary ml-auto">Event page</a>
</div>
@endif
