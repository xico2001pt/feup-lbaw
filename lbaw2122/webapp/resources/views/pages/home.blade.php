@extends('layouts.base')

@section('title', 'Eventful')

@section('breadcrumbs')
<li class="breadcrumb-item active" aria-current="page">Home</li>
@endsection

@section('content')
<div class="container">
    <div class="row justify-content-center my-5">
        <div class="col my-auto me-5">
            <h1 class="homepage-title text-center display-1 mb-5"> Eventful </h1>
            <p class="lead text-center">An event platform for all your needs</p>
            <p class="lead text-center">Eventfuls grants you the ability to organize and participate in events, gathering all information needed in one single space.</p>
            <div class="d-grid gap-2 d-sm-flex justify-content-sm-center my-5">
                @can('create', App\Models\Event::class)
                    <a id="homeCreateEventButton" href="{{ route('createEventForm') }}" class="btn btn-primary btn-lg px-4 gap-3">Create Event</a>
                @else
                    @if(!Auth::check())
                        <a id="homeCreateEventButton" href="{{ route('createEventForm') }}" class="btn btn-primary btn-lg px-4 gap-3">Create Event</a>
                    @else
                        <a class="btn btn-danger btn-lg px-4 gap-3">Create Event</a>
                    @endif
                @endcan
                <a id="homeBrowseEventButton" href="{{ route('events') }}" class="btn btn-outline-secondary btn-lg px-4">Browse Events</a>
            </div>
        </div>
        <div class="col-4 my-5">
            <img class="img-fluid w-100" src="{{url('/images/home.svg')}}" alt="Image of an event"/>
        </div>
    </div>
</div>

@endsection
