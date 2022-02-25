@extends('layouts.form')

@section('title', 'Eventful - Edit Profile')
@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('user', ['user_id' => $user->id]) }}">Profile</a></li>
<li class="breadcrumb-item active" aria-current="page">Edit</li>
@endsection
@section('form-title', 'Edit Profile')

@section('form-content')
<form method="post" action="{{ route('updateUser', ['user_id' => $user->id]) }}" enctype="multipart/form-data">
    {{ method_field('PUT') }}
    {{ csrf_field() }}

    <div class="form-group mb-3">
    <label for="username" class="form-label">Username</label>
    <input id="username" type="text" name="username" placeholder="{{ $user->username }}" class="form-control @if($errors->has('username')) is-invalid @endif">
    @if ($errors->has('username'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('username') }}
    </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label for="Name" class="form-label">Name</label>
    <input id="name" type="text" name="name" placeholder="{{ $user->name }}" class="form-control @if($errors->has('name')) is-invalid @endif">
    @if ($errors->has('name'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('name') }}
    </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label class="form-label" for="profile_pic">Profile Picture</label>
    <input type="file" name="profile_pic" class="form-control @if($errors->has('profile_pic')) is-invalid @endif" id="profile_pic" accept="image/*">
    @if ($errors->has('profile_pic'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('profile_pic') }}
    </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label for="description" class="form-label">Description</label>
    <textarea id="description" maxlength="8192" type="textarea" name="description" placeholder="{{ $user->description }}" class="form-control @if($errors->has('description')) is-invalid @endif"></textarea>
    @if ($errors->has('description'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('description') }}
    </div>
    @endif
    </div>

    <div class="form-group mb-3">
    <label for="email" class="form-label">Email</label>
    <input id="email" type="email" name="email" placeholder="{{ $user->email }}" class="form-control @if($errors->has('email')) is-invalid @endif">
    @if ($errors->has('email'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('email') }}
    </div>
    @endif
    </div>
    
    <div class="form-group mb-3">
    <label for="birthdate" class="form-label">Birthdate</label>
    <input id="birthdate" type="datetime-local" name="birthdate" placeholder="{{ $user->birthdate }}" class="form-control @if($errors->has('birthdate')) is-invalid @endif">
    @if ($errors->has('birthdate'))
    <div class="invalid-feedback d-block">
        {{ $errors->first('birthdate') }}
    </div>
    @endif
    </div>

    @if(!is_null($user->password))
        <div class="form-group mb-3">
        <label for="password" class="form-label">Password</label>
        <input id="password" type="password" name="password" class="form-control @if($errors->has('password')) is-invalid @endif">
        <span class="form-text">Password must be at least 8 characters long and contain lowercase, uppercase, numerical and special characters.</span>
        @if ($errors->has('password'))
        <div class="invalid-feedback d-block">
            {{ $errors->first('password') }}
        </div>
        @endif
        </div>

        <div class="form-group mb-3">
        <label for="password-confirm">Confirm Password</label>
        <input id="password-confirm" class="form-control" type="password" name="password_confirmation">
        </div>
    @endif

    <button type="submit" class="btn btn-primary">
        Submit
    </button>
</form>
@endsection
