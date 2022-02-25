@extends('layouts.form')

@section('title', 'Eventful - Register')
@section('form-title', 'Register')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Register</li>
@endsection

@section('form-content')
<form method="POST" action="{{ route('register') }}">
    {{ csrf_field() }}

    <div class="form-group mb-3">
        <label for="username" class="form-label required-label">Username</label>
        <input id="username" class="form-control @if($errors->has('username')) is-invalid @endif" type="text" name="username" value="{{ old('username') }}" placeholder="Enter username" required autofocus>
        @if ($errors->has('username'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('username') }}
        </div>
        @endif
    </div>

    <div class="form-group mb-3">
        <label for="name" class="form-label required-label">Name</label>
        <input id="name" class="form-control @if($errors->has('name')) is-invalid @endif" type="text" name="name" value="{{ old('name') }}" placeholder="Enter name" required>
        @if ($errors->has('name'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('name') }}
        </div>
        @endif
    </div>

    <div class="form-group mb-3">
        <label for="email" class="form-label required-label">Email Address</label>
        <input id="email" class="form-control @if($errors->has('email')) is-invalid @endif" type="email" name="email" value="{{ old('email') }}" placeholder="Enter email" required>  
        @if ($errors->has('email'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('email') }}
        </div>
        @endif
    </div>

    <div class="form-group mb-3">
        <label for="birthdate" class="form-label required-label">Birthdate</label>
        <input id="birthdate" class="form-control @if($errors->has('birthdate')) is-invalid @endif" type="date" name="birthdate" value="{{ old('birthdate') }}" required>
        @if ($errors->has('birthdate'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('birthdate') }}
        </div>
        @endif
    </div>

    <div class="form-group mb-3">
        <label for="password" class="form-label required-label">Password</label>
        <input id="password" class="form-control @if($errors->has('password')) is-invalid @endif" type="password" name="password" required>
        <span class="form-text">Password must be at least 8 characters long and contain lowercase, uppercase, numerical and special characters.</span>
        @if ($errors->has('password'))
        <div class="invalid-feedback d-block">
        {{ $errors->first('password') }}
        </div>
        @endif
    </div>

    <div class="form-group mb-3">
        <label for="password-confirm" class="form-label">Confirm Password</label>
        <input id="password-confirm" class="form-control" type="password" name="password_confirmation" required>
    </div>

    <button type="submit" class="btn btn-primary">
        Register
    </button>
    <a class="btn btn-outline-secondary ms-3 py-3" href="{{ route('googleRedirectOAuth') }}"><i class="bi bi-google me-2"></i>Register with Google</a>
    <a class="ms-3" href="{{ route('login') }}">Login</a>
</form>
@endsection
