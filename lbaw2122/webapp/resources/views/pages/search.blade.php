@extends('layouts.base')

@section('title', 'Eventful - Search')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('events') }}">Events</a></li>
<li class="breadcrumb-item active" aria-current="page">Search</li>
@endsection

@section('content')
<script src="{{ asset('/js/requestsManagement.js') }}" ></script>

<button class="btn btn-primary ms-5" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasFilters" aria-controls="offcanvasFilters">
  Filters <span><i class="bi bi-filter"></i></span>
</button>

<div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasFilters" aria-labelledby="offcanvasFiltersLabel">
  <div class="offcanvas-header">
    <h3 class="offcanvas-title" id="offcanvasFiltersLabel">Filters</h3>
    <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
  </div>
  <div class="offcanvas-body">
    <form method="GET" action="{{ url('event') }}">
        <div class="form-group mb-3">
            <input type="hidden" name="search" value="{{ $search }}">

            <fieldset>
                <legend>Tags</legend>
                @foreach ($tags as $tag)
                    @include('partials.tag', ['selected' => $tagsSelected])
                @endforeach
            </fieldset>

            <label for="after_date" class="form-label font-weight-bold">After</label>
            <input id="after_date" type="datetime-local" name="after" class="form-control" value="{{ $after_date }}">

            <label for="before_date" class="form-label">Before</label>
            <input id="before_date" type="datetime-local" name="before" class="form-control" value="{{ $before_date }}">
        </div>
        <button type="submit" class="btn btn-dark">Apply</button>
    </form>
  </div>
</div>

<div class="container">
    <h1 class="text-center my-5">Searching for: {{ $search }}</h1>
    <div class="row">
        <div class="col">
            <div class="row justify-content-center">
                @forelse($events as $event)
                    @include('partials.eventCard', ['event' => $event])
                @empty
                    <h3 class="w-50 text-justify">No event matches your criteria, try tweaking the search parameters</h3>
                @endforelse
            </div>
            <div class="row justify-content-center">
            {{ $events->withQueryString()->links() }}
            </div>
        </div>
    </div>
</div>
@endsection