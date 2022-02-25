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
            <a class="nav-link" href="{{ url('/about')}}">About Us</a>
            </li>
            <li class="nav-item mb-0">
            <a class="nav-link" href="{{ url('/contact') }}">Contact Us</a>
            </li>
            @if(Auth::check() && Auth::user()->is_admin)
            <li class="nav-item mb-0">
            <a class="nav-link" href="{{ url('/admin') }}">Admin Panel</a>
            </li>
            @endif
        </ul>
        
        <form class="form-inline mx-auto mb-0 w-25" action="{{ url('/event')}}">
            <input class="form-control text-center h-70" type="search" id="search" name="search" placeholder="Search">
        </form>

        <ul class="navbar-nav ms-auto">
            @if (!Auth::check())
            <li class="nav-item mb-0">
                <a class="nav-link" href="{{ url('/login') }}">Login</a>
            </li>
            <li class="nav-item mb-0">
                <a class="nav-link" href="{{ url('/register') }}">Register</a>
            </li>
            @else
            <li class="nav-item mb-0 me-1">
                <button type="button" class="btn btn-sm btn-outline-secondary notificationButton px-2 py-0 position-relative" onclick="toggleNotifications()">
                    <i class="bi text-white bi-bell"></i>
                    <span id="notificationBadge" class="position-absolute top-0 start-100 translate-middle p-2 bg-danger rounded-circle" hidden>
                        <span class="visually-hidden">New alerts</span>
                    </span>
                </button>
                
            </li>
            <li class="nav-item mb-0">
                <a class="nav-link" href="{{ url('/logout') }}">Logout</a>
            </li>
            <li class="nav-item mb-0">
                <a class="nav-link text-white" href="{{ url('/user/' . Auth::id()) }}">
                    {{ Auth::user()->name }}
                    @if (!is_null(Auth::user()->block_motive))
                    (Blocked)
                    @endif
                </a>
            </li>
            @endif
        </ul>
        </div>
    </div>
    </nav>
    @include('partials.notifications')
    <nav aria-label="breadcrumb">
        <ol class="mx-5 my-5 breadcrumb">
            @yield('breadcrumbs')
        </ol>
    </nav>
    <section id="content">
    @yield('content')
    </section>
</main>
@endsection