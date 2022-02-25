@extends('layouts.app')

@section('body')
<main>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow">
    <div class="container-fluid">
        <a class="navbar-brand" href="{{ url('/') }}">Eventful</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto">
            <li class="nav-item mb-0">
            <a class="nav-link" href="{{ url('/admin')}}">Home</a>
            </li>
            <li class="nav-item mb-0">
            <a class="nav-link" href="{{ url('/admin/users')}}">Users</a>
            </li>
            <li class="nav-item mb-0">
            <a class="nav-link" href="{{ url('/admin/unblockAppeals') }}">Unblock Appeals</a>
            </li>
            <li class="nav-item mb-0">
            <a class="nav-link" href="{{ url('/admin/reports') }}">Reports</a>
            </li>
        </ul>
        
        <ul class="navbar-nav ms-auto">
            <li class="nav-item mb-0">
                <a class="nav-link" href="{{ url('/logout') }}">Logout</a>
            </li>
            <li class="nav-item mb-0">
            <a class="nav-link text-white" href="{{ url('/user/' . Auth::id()) }}">{{ Auth::user()->name }}</a>
            </li>
        </ul>
        </div>
    </div>
    </nav>
    <nav aria-label="breadcrumb">
        <ol class="mx-5 my-5 breadcrumb">
            @yield('breadcrumbs')
        </ol>
    </nav>
    <section id="content">
        <div class="container">
        @yield('content')
        </div>
    </section>
</main>
@endsection