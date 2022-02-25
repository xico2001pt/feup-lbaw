@extends('layouts.form')

@section('title', 'Eventful - Edit Event')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('events') }}">Events</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('event', ['event_id' => $event->id]) }}">{{ $event->title }}</a></li>
<li class="breadcrumb-item active" aria-current="page">Edit</li>
@endsection

@section('form-title', 'Edit Event')

@section('form-content')
<form method='post' action="{{ route('updateEvent', ['event_id' => $event->id]) }}" enctype="multipart/form-data">
    {{ method_field('PUT') }}
    {{ csrf_field() }}

    <div class="form-group mb-3">
    <label for="title" class="form-label">Title</label>
    <input id="title" type="text" name="title" placeholder="{{ $event->title }}" class="form-control @if($errors->has('title')) is-invalid @endif">
    @if ($errors->has('title'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('title') }}
        </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label class="form-label" for="event_image">Event Image</label>
    <input type="file" name="event_image" class="form-control @if($errors->has('event_image')) is-invalid @endif" id="event_image" accept="image/*">
    @if ($errors->has('event_image'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('event_image') }}
        </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label for="description" class="form-label">Description</label>
    <textarea id="description" maxlength="8192" type="textarea" name="description" placeholder="{{ $event->description }}" class="form-control @if($errors->has('description')) is-invalid @endif"></textarea>
    @if ($errors->has('description'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('description') }}
        </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label for="location" class="form-label">Location</label>
    <input id="location" type="text" name="location" placeholder="{{ $event->location }}" class="form-control @if($errors->has('location')) is-invalid @endif">
    @if ($errors->has('location'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('location') }}
        </div>
    @endif
    </div>
    
    <div class="form-group mb-3">
    <label for="realization_date" class="form-label">Realization Date</label>
    <input id="realization_date" type="datetime-local" name="realization_date" placeholder="{{ $event->realization_date }}" class="form-control @if($errors->has('realization_date')) is-invalid @endif">
    @if ($errors->has('realization_date'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('realization_date') }}
        </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label for="visibility" class="form-check-label pe-2">Visibility</label>
    <a href="#visibility" data-bs-toggle="tooltip" title="Anyone can view a public event's details (title, description and image). A private event can only be viewed by it's attendees."><i class="bi bi-question-octagon text-secondary ml-auto"></i></a>
    <select class="form-control @if($errors->has('visibility')) is-invalid @endif"  id="visibility" name="visibility">
        <option value="public" {{ $event->is_visible ? "selected" : "" }}>Public</option>
        <option value="private" {{ $event->is_visible ? "" : "selected" }}>Private</option>
    </select>
    @if ($errors->has('visibility'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('visibility') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="access" class="form-check-label pe-2">Access</label>
    <a href="#access" data-bs-toggle="tooltip" title="Anyone can join a public access event, in a private event you can accept or deny requests to join."><i class="bi bi-question-octagon text-secondary ml-auto"></i></a>
    <select class="form-control @if($errors->has('access')) is-invalid @endif" placeholder="{{ old('access') }}" id="access" name="access">
    <option value="public" {{ $event->is_accessible ? "selected" : "" }}>Public</option>
    <option value="private" {{ $event->is_accessible ? "" : "selected" }}>Private</option>
    </select>
    @if ($errors->has('access'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('access') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <div class="dropdown">
    <a class="btn btn-secondary dropdown-toggle" data-bs-auto-close="outside" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
        Tags
    </a>
    <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
        @foreach($tags as $tag)
        <li>
        <a class="dropdown-item">
        <div class="form-check">
            <input class="form-check-input" type="checkbox" id="{{ $tag->id }}" name="tag[]" value="{{ $tag->id }}" @if($event->tags()->get()->contains($tag)) checked @endif>
            <label class="w-100 form-check-label" for="{{ $tag->id }}">{{ $tag->name }}</label>            
        </div>
        </a>
        </li>
        @endforeach
    </ul>
    </div>
</div>

<div class="form-group mb-3">
    <label for="capacity" class="form-label">Capacity</label>        
    <input id="capacity" type="text" name="capacity" placeholder="{{ $event->capacity }}" class="form-control @if($errors->has('capacity')) is-invalid @endif">
    @if ($errors->has('capacity'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('capacity') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="price" class="form-label">Price</label>
    <input id="price" type="number" name="price" placeholder="{{ $event->price }}" class="form-control @if($errors->has('price')) is-invalid @endif">
    @if ($errors->has('price'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('price') }}
    </div>
    @endif
</div>

<button type="submit" class="btn btn-primary">
    Submit
</button>
</form>
@endsection
