@extends('layouts.base')

@section('title', 'Eventful - Page Not Found')

@section('content')
<div class="container mt-5">
    <div class="jumbotron text-center mb-5">
        <h1 class="display-2">Page Not Found.</h1>    
    </div>
    <div class="row justify-content-center">
        <img class="img-fluid w-50" src="{{url('/images/404.svg')}}" alt="Admin image"/>
    </div>
</div>


@endsection
