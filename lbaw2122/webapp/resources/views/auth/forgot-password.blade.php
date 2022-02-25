@extends('layouts.form')

@section('title', 'Eventful - Forgot Password')
@section('form-title', 'Forgot Password')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('login') }}">Login</a></li>
<li class="breadcrumb-item active" aria-current="page">Forgot Password</li>
@endsection

@section('form-content')
<form method="POST" action="{{ route('passwordSendEmail') }}">
    {{ csrf_field() }}
    
    <div class="form-group mb-5">
        <label for="email" class="form-label">Email</label>
        <input type="email" class="form-control @if($errors->has('email')) is-invalid @elseif(\Session::has('status')) is-valid @endif" name="email" id="email" aria-describedby="emailHelp" placeholder="Enter email" value="{{ old('email') }}" required autofocus>
        @if ($errors->has('email'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('email') }}
        </div>
        @endif

        @if(\Session::has('status'))
        <div class="valid-feedback d-block">
            {{ \Session::get('status') }}
        </div>
        @endif
    </div>

    <button type="submit" class="btn btn-primary">Send reset request</button>
</form>
@endsection


