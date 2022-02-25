@extends('layouts.base')

@section('title', 'Eventful')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Events</li>
@endsection

@section('content')
<script src="{{ asset('/js/requestsManagement.js') }}" ></script>
<div class="container">
    <div class="row justify-content-center my-5">
        <div class="col">
            <h1 class="homepage-title text-center mb-5"> Eventful </h1>
            <p class="lead text-center">An event platform for all your needs</p>
        </div>
    </div>
    <div class="row justify-content-center">
        @each('partials.eventCard', $events, 'event')
    </div>
    <div class="row justify-content-center">
        {{ $events->render() }}
    </div>
</div>

@endsection
