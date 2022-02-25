@extends('layouts.adminBase')

@section('title', 'Eventful - Admin Panel')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Admin</li>
@endsection

@section('content')

<div class="container mt-5">
    <div class="jumbotron text-center mb-5">
        <h1 class="display-2">You're an admin Harry.</h1>    
    </div>
    <div class="row justify-content-center">
        <img class="img-fluid w-50" src="{{url('/images/admin.svg')}}" alt="Admin image"/>
    </div>
</div>

@endsection
