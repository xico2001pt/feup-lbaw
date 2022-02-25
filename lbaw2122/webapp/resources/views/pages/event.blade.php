@extends('layouts.base')

@section('title', 'Eventful - ' . $event->title)

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('events') }}">Events</a></li>
<li class="breadcrumb-item active" aria-current="page">{{ $event->title }}</li>
@endsection

@section('content')
<script type="text/javascript" src="{{ asset('/js/requestsManagement.js') }}" ></script>


@can('viewContent', $event)
<script type="text/javascript" src="{{ asset('/js/attendeeManagement.js') }}"></script>
<script type="text/javascript" src="{{ asset('/js/commentManagement.js') }}"></script>

<!-- Main Quill library -->
<script src="//cdn.quilljs.com/1.3.6/quill.js"></script>
<script src="//cdn.quilljs.com/1.3.6/quill.min.js"></script>

<!-- Theme included stylesheets -->
<link href="//cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link href="//cdn.quilljs.com/1.3.6/quill.bubble.css" rel="stylesheet">

<script type="text/javascript" src="{{ asset('/js/postManagement.js') }}" defer></script>
@include('partials.attendeeListModal', ['event' => $event])
@include('partials.inviteUserModal', ['event' => $event])
@include('partials.postEditorModal', ['event_id' => $event->id])
@endcan

<div class="container">
    <div class="row my-5">
        <div class="col">
            <img class="border border-3 border-secondary rounded" src='{{ url("/event/$event->id" . "/image") }}' alt="Event image">
        </div>
        <div class="col border border-3 border-secondary rounded">
            <h1 class="display-2 text-center">{{ $event->title }}</h1>
            <p class="lead text-center">Created by {{ $event->host()->first()->username }}<p>
            <div class="text-center">
            @include('partials.eventTags', ['tags' => $event->tags()->get()])                
            </div>

            <div class="row">
                <div class="col-sm">
                    @include('partials.eventDetails', ['event' => $event])
                </div>
                <div class="col-sm-3">
                    <!-- Host buttons -->
                    @can('update', $event)
                    <a class="btn btn-secondary mb-2 w-100" href="{{ route('updateEventForm', ['event_id' => $event->id]) }}">Update</a>
                    @endcan

                    @can('delete', $event)
                    <form class="mb-2 w-100" method='post' action='{{ route("deleteEvent", ["event_id" => $event->id]) }}'>
                        {{ method_field('DELETE') }}
                        {{ csrf_field() }}
                        <button type="submit" class="btn btn-danger mb-2 w-100">
                            Delete event
                        </button>
                    </form>
                    @endcan

                    @can('host', $event)
                        @if(!$event->is_accessible)
                        @include('partials.requestsListModal', ['requests' => $event->requests()->get()])
                        <a class="btn btn-secondary mb-2 w-100" type="button" data-bs-toggle="modal" href="#requests">Requests</a>
                        @endif
                    @endcan

                    <!-- Regular user buttons -->
                    @can('join', $event)
                    <form method="post" action='{{ route("joinEvent", ["event_id" => $event->id]) }}'>
                        {{ csrf_field() }}
                        <button type="submit" class="btn btn-success mb-2 w-100">
                            Join
                        </button>
                    </form>
                    @elsecan('request', $event)
                        @if(is_null($event->requests()->where('user_id', Auth::id())->where('event_id', $event->id)->first()))
                            <a id="request{{ $event->id }}" onclick="sendRequest('{{ $event->id }}')" class="btn btn-danger ml-auto">Request to Join</a>
                        @else
                            <span class="text-primary">Request Sent</span>
                        @endif
                    @elsecan('leave', $event)
                    <form method="post" action='{{ route("leaveEvent", ["event_id" => $event->id]) }}'>
                        {{ method_field('DELETE') }}
                        {{ csrf_field() }}
                        <button type="submit" class="btn btn-danger mb-2 w-100">
                            Leave
                        </button>
                    </form>
                    @endcan

                    @can('viewContent', $event)
                    <a class="btn btn-secondary mb-2 w-100" type="button" data-bs-toggle="modal" href="#attendees">View Attendees</a>
                    <a class="btn btn-secondary mb-2 w-100" type="button" data-bs-toggle="modal" onclick="clearInviteFeedback()" href="#inviteUser">Invite</a>
                    @endcan
                </div>
            </div>
            <div class="row my-5">
                <div class="col">
                    <h2 class="display-4">Description</h2>
                    <p>{{ $event->description }}</p>
                </div>
            </div>
        </div>
    </div>
    @can('viewContent', $event)
    <div class="row my-5">
        <div class="col-5">
            @include('partials.comments', ['comments' => $event->comments()->orderBy('creation_date', 'DESC')->get()])
        </div>
        <div class="col">
            @include('partials.posts', ['posts' => $event->posts()->orderBy('creation_date', 'DESC')->get(), 'event' => $event])
        </div>
    </div>
    @endcan
</div>
@endsection
