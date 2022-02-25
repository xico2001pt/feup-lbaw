@extends('layouts.adminBase')

@section('title', 'Eventful - User Management')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('admin') }}">Admin</a></li>
<li class="breadcrumb-item active" aria-current="page">User Management</li>
@endsection

@section('content')
<script type="text/javascript" src="{{ asset('/js/administration.js') }}" ></script>
<div class="container mt-5">
    <div class="jumbotron text-center mb-5">
        <h1 class="display-2">User Management</h1>
    </div>

    <div class="row justify-content-center mb-5">
        <div class="col">
            <form class="form-inline mx-auto mb-0 w-25" action="{{ route('adminUserList') }}">
                <input class="form-control mx-auto my-auto text-center w-100" type="search" id="username" name="username" placeholder="Username">
            </form>
        </div>
    </div>
    
    <div class="row justify-content-center">
        @each('partials.blockUserModal', $users, 'user')
        @each('partials.adminUserCard', $users, 'user')
    </div>
    <div class="row justify-content-center">
        {{ $users->render() }}
    </div>
</div>


@endsection
