@if(Auth::check())
    <div style="position: absolute; right: 0; z-index:1;">
    <div class="toast mb-1" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false" id="noNotificationsToast" hidden>
        <div class="toast-header">
            <strong class="me-auto">No notifications</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close" onclick="hideNotifications()"></button>
        </div>
        <div class="toast-body">
            You've caught up with the news :)
        </div>
    </div>
    @foreach(Auth::user()->unreadNotifications as $notification)
    <div class="toast mb-1" role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false" id="notification{{$notification->id}}">
        <div class="toast-header">
            <!--<img src="..." class="rounded me-2" alt="...">-->
            <strong class="me-auto">{{ $notification->data['title'] }}</strong>
            <small>{{ $notification->created_at->diffForHumans() }}</small>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close" onclick="markAsRead('{{ Auth::id() }}', '{{$notification->id}}')"></button>
        </div>
        <div class="toast-body">
            @switch($notification->type)
                @case('App\Notifications\InviteReceived')
                    @include('partials.notifications.genericNotification', 
                        ['text' => "You've been invited to join the event",
                        'strong' => $notification->data['event'],
                        'includeEventButton' => true,
                        'event_id' => $notification->data['event_id'],
                    ])
                @break
                @case('App\Notifications\RequestAccepted')
                    @include('partials.notifications.genericNotification', 
                        ['text' => "Your request to join the event has been accepted",
                        'includeEventButton' => true,
                        'event_id' => $notification->data['event_id'],
                    ])
                @break
                @case('App\Notifications\RequestDenied')
                    @include('partials.notifications.genericNotification', 
                        ['text' => "Your request to join the event has been denied",
                        'includeEventButton' => false,
                    ])
                @break
                @case('App\Notifications\EventCancelled')
                    @include('partials.notifications.genericNotification', 
                        ['text' => "This event has been cancelled",
                        'includeEventButton' => false,
                    ])
                @break
                @case('App\Notifications\Contact')
                    @include('partials.notifications.contactNotification',
                        ['email' => $notification->data['email'],
                        'message' => $notification->data['message']])
                @break
            @endswitch
        </div>
    </div>
    @endforeach
    </div>
@endif

