@extends('layouts.base')

@section('title', 'Eventful - About Us')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">About</li>
@endsection

@section('content')

<div class="container">
    <section class="jumbotron text-center mb-5">
        <h1 class="jumbotron-heading display-1">Eventful</h1>
        <p class="lead text-muted mb-0">An event platform for all your needs.</p>
        <p class="lead text-muted">Eventfuls grants you the ability to organize and participate in events, gathering all information needed in one single space.</p>
    </section>

    <section>
    <div class="row justify-content-center mb-5">
        <div class="col-md-6">
            <h2 class="display-5">Our objective</h2>
            <p>Our focus is creating an online platform that encourages the gathering of communities, families and friends by smoothing out the organization process becoming a single hub for everyone's needs.</p>
        </div>
        <div class="col-md-3">
            <img class="img-responsive" src="{{url('/images/our_objective.svg')}}" alt="Friends meeting">
        </div>
    </div>
    <div class="row justify-content-center mb-5">
        <div class="col-md-3">
            <img class="img-responsive" src="{{url('/images/team.svg')}}" alt="Team">
        </div>
        <div class="col-md-6">
            <h2 class="display-5">Who are we</h2>
            <p>Eventful's development started in October 2021, being an projecte developed for the Database and Web Applications Laboratory curricular unit at FEUP.</p>
            <span><strong>Group:</strong> lbaw2122</span>
            <p class="mb-0"><strong>Team:</strong></p>
            <ul>
                <li class="mb-0">Adriano Soares, up201904873@fe.up.pt</li>
                <li class="mb-0">Filipe Campos, up201905609@fe.up.pt</li>
                <li class="mb-0">Francisco Cerqueira, up201905337@fe.up.pt</li>
                <li class="mb-0">Vasco Alves, up201808031@fe.up.pt</li>
            </ul>
        </div>
    </div>
    </section>
</div>

@endsection