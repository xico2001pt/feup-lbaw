@extends('layouts.form')

@section('title', 'Eventful - Reset Password')
@section('form-title', 'Reset Password')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Reset Password</li>
@endsection

@section('form-content')
<form method="POST" action="{{ route('passwordUpdate') }}">
    {{ csrf_field() }}

    <input type="hidden" id="token" name="token" value="{{$token}}">
    
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
        <label for="password" class="form-label">Password</label>
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

    <button type="submit" class="btn btn-primary">Reset Password</button>
</form>
@endsection


