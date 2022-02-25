@extends('layouts.form')

@section('title', 'Eventful - Register')
@section('form-title', 'Register')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Register</li>
@endsection

@section('form-content')
<form method="POST" action="{{ route('googleRegisterOAuth') }}">
    {{ csrf_field() }}

    <div class="form-group mb-3">
        <label for="username" class="form-label">Username</label>
        <input id="username" class="form-control @if($errors->has('username')) is-invalid @endif" type="text" name="username" value="{{ old('username') }}" placeholder="Enter username" required autofocus>
        @if ($errors->has('username'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('username') }}
        </div>
        @endif
    </div>    

    <div class="form-group mb-3">
        <label for="birthdate" class="form-label">Birthdate</label>
        <input id="birthdate" class="form-control @if($errors->has('birthdate')) is-invalid @endif" type="date" name="birthdate" value="{{ old('birthdate') }}" required>
        @if ($errors->has('birthdate'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('birthdate') }}
        </div>
        @endif
    </div>

    <button type="submit" class="btn btn-primary">
        Register
    </button>
</form>
@endsection
