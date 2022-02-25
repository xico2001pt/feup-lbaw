@extends('layouts.form')

@section('title', 'Eventful - Contact Us')
@section('form-title', 'Contact Us')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Contact</li>
@endsection


@section('form-content')
<form method="POST" action="{{ route('contact') }}">
{{ csrf_field() }}

<div class="form-group mb-3">
    <label for="name" class="form-label">Name</label>
    <input id="name" class="form-control @if($errors->has('name')) is-invalid @endif" type="text" name="name" value="{{ old('name') }}" placeholder="Enter name" required autofocus>
    @if ($errors->has('name'))
    <div class="invalid-feedback d-block">
    {{ $errors->first('name') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="email" class="form-label">Email</label>
    <input type="email" class="form-control @if($errors->has('email')) is-invalid @endif" name="email" id="email" aria-describedby="emailHelp" placeholder="Enter email" value="{{ old('email') }}" required autofocus>
    @if ($errors->has('email'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('email') }}
    </div>
    @endif
</div>

<div class="form-group mb-3">
    <label for="message" class="form-label">Message</label>
    <textarea id="message" maxlength="2048" type="textarea" name="message" class="form-control @if($errors->has('message')) is-invalid @endif" required>{{ old('message') }}</textarea>
    @if ($errors->has('message'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('message') }}
    </div>
    @endif
</div>

<button type="submit" class="btn btn-primary">Send message</button>
</form>
@endsection
