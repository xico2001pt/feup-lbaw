@extends('layouts.form')

@section('title', 'Eventful - Login')
@section('form-title', 'Login')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Login</li>
@endsection

@section('form-content')
<form method="POST" action="{{ route('login') }}">
    {{ csrf_field() }}
    
    <div class="form-group mb-3">
        <label for="email" class="form-label required-label">Email</label>
        <input type="email" class="form-control @if($errors->has('email')) is-invalid @endif" name="email" id="email" aria-describedby="emailHelp" placeholder="Enter email" value="{{ old('email') }}" required autofocus>
        @if ($errors->has('email'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('email') }}
        </div>
        @endif
    </div>

    <div class="form-group mb-3">
        <label for="password" class="form-label required-label">Password</label>
        <input type="password" class="form-control  @if($errors->has('password')) is-invalid @endif" name="password" id="password" placeholder="Enter password" value="{{ old('password') }}" required>
        @if ($errors->has('password'))
        <span class="invalid-feedback" role="alert">
            <strong>{{ $errors->first('password') }}</strong>
        </span>
        @endif
    </div>
    
    <div class="form-check mb-3">
        <input type="checkbox" class="form-check-input" name="remember" {{ old('remember') ? 'checked' : '' }}>
        <label class="form-check-label" for="checkbox">Remember me</label>
    </div>

    <button type="submit" class="btn btn-primary">Login</button>
    <a class="btn btn-outline-secondary ms-3 py-3" href="{{ route('googleRedirectOAuth') }}"><i class="bi bi-google me-2"></i>Login with Google</a>
    <a class="ms-3" href="{{ route('register') }}">Register</a>
    <a class="ms-3" href="{{ route('passwordRequest') }}">Forgot password?</a>
</form>
@endsection


