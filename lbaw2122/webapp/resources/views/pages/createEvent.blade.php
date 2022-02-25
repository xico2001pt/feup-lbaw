@extends('layouts.form')

@section('title', 'Eventful - Create Event')
@section('form-title', 'Create Event')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Create Event</li>
@endsection

@section('form-content')

<form method="POST" action="{{ route('createEvent') }}" enctype="multipart/form-data">
{{ csrf_field() }}
<div class="form-group mb-3">
    <label for="title" class="form-label required-label">Title</label>
    <input id="title" type="text" name="title" value="{{ old('title') }}" class="form-control @if($errors->has('title')) is-invalid @endif"required>
    @if ($errors->has('title'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('title') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label class="form-label" for="event_image">Event Image</label>
    <input type="file" name="event_image" value="{{ old('event_image') }}" class="form-control @if($errors->has('event_image')) is-invalid @endif" id="event_image" accept="image/*">
    @if ($errors->has('event_image'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('event_image') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="description" class="form-label required-label">Description</label>
    <textarea id="description" maxlength="8192" type="textarea" name="description" class="form-control @if($errors->has('description')) is-invalid @endif" required>{{ old('description') }}</textarea>
    @if ($errors->has('description'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('description') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="location" class="form-label required-label">Location</label>
    <input id="location" type="text" name="location" value="{{ old('location') }}" class="form-control @if($errors->has('location')) is-invalid @endif" required>
    @if ($errors->has('location'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('location') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="realization_date" class="form-label required-label">Realization Date</label>
    <input id="realization_date" type="datetime-local" value="{{ old('realization_date') }}" name="realization_date" class="form-control @if($errors->has('realization_date')) is-invalid @endif" required>
    @if ($errors->has('realization_date'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('realization_date') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="visibility" class="form-check-label required-label pe-2">Visibility</label>
    <a href="#visibility" data-bs-toggle="tooltip" title="Anyone can view a public event's details (title, description and image). A private event can only be viewed by it's attendees."><i class="bi bi-question-octagon text-secondary ml-auto"></i></a>
    <select class="form-control @if($errors->has('visibility')) is-invalid @endif"  value="{{ old('visibility') }}" id="visibility" name="visibility" required>
    <option value="public" {{ old('visibility') ? "selected" : "" }}>Public</option>
    <option value="private" {{ old('visibility') ? "" : "selected" }}>Private</option>
    </select>
    @if ($errors->has('visibility'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('visibility') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="access" class="form-check-label required-label pe-2">Access</label>
    <a href="#access" data-bs-toggle="tooltip" title="Anyone can join a public access event, in a private event you can accept or deny requests to join."><i class="bi bi-question-octagon text-secondary ml-auto"></i></a>
    <select class="form-control @if($errors->has('access')) is-invalid @endif" value="{{ old('access') }}" id="access" name="access" required>
    <option value="public" {{ old('access') ? "selected" : "" }}>Public</option>
    <option value="private" {{ old('access') ? "" : "selected" }}>Private</option>
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
                <input class="form-check-input" type="checkbox" id="{{ $tag->id }}" name="tag[]" value="{{ $tag->id }}">
                <label class="w-100 form-check-label" for="{{ $tag->id }}">{{ $tag->name }}</label>            
            </div>
            </a>
            </li>
            @endforeach
        </ul>
    </div>
</div>

<div class="form-group mb-3">
    <label for="capacity" class="form-label required-label">Capacity</label>
    <a href="#capacity" data-bs-toggle="tooltip" title="If the event has unlimited capacity, represent it with a 0."><i class="bi bi-question-octagon text-secondary ml-auto"></i></a>
    <input id="capacity" type="number" step="1" min="0" name="capacity" value="{{ old('capacity') }}" class="form-control @if($errors->has('capacity')) is-invalid @endif" required>
    @if ($errors->has('capacity'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('capacity') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="price" class="form-label required-label">Price</label>
    <input id="price" type="number" step=".01" min="0" name="price" value="{{ old('price') }}" class="form-control @if($errors->has('price')) is-invalid @endif" required>
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
