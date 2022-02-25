@can('viewInformation', $event)
<div class="col-auto mb-5 rounded-lg">
    <div class="card h-100 @can('isHost', $event) border-success border-2 @elsecan('isAttendee', $event) border-primary border-2 @endcan rounded shadow-lg">
      <img class="card-img-top" src='{{ url("/event/$event->id" . "/image") }}' alt="Event image">
      <div class="card-body d-flex flex-column">
        <h3 class="card-title"><b>{{ $event->title }}</b></h3>
        <p class="card-text">{{ $event->description }}</p>
        <div class="mt-auto">
          @include('partials.eventTags', ['tags' => $event->tags()->get()])
          @include('partials.eventDetails', ['event' => $event])
        </div>
      </div>
      <div class="card-footer">
        @include('partials.eventCardButtons', ['event' => $event])
        @can('isHost', $event) 
          <span class="text-success float-right">Hosting</span>
        @elsecan('isAttendee', $event)
          <span class="text-primary float-right">Attending</span>
        @endcan
      </div>
    </div>
</div>
@endcan