@extends('layouts.base')

@section('title', 'Eventful - ' . $user->username)

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item active" aria-current="page">Profile</li>
@endsection

@section('content')
<div class="container my-5">
    <div class="d-flex flex-row justify-content-start">
        <img class="border border-2 border-secondary rounded w-25" src="{{ route('userImage', ['user_id' => $user->id]) }}" alt="Profile Picture" style="min-width: 28rem;">
        <div class="p-5 mx-5 border-secondary rounded">
            <h1 class="display-3 text-center">{{ $user->username }}</h1>
            <div class="my-2">
                <span>
                    <i class="bi bi-person"></i>
                    {{ $user->name }}
                </span>
            </div>
            <div class="my-2">
                <span>
                    <i class="bi bi-envelope-check"></i>
                    {{ $user->email }}
                </span>
            </div>
            <div class="my-2">
                <span>
                    <i class="bi bi-calendar-check"></i>
                    {{ $user->birthdate }}
                </span>
            </div>
            @if($user->description != null)
            <div class="my-2">
                <span>
                    <i class="bi bi-card-text"></i>
                    Description
                </span>
                <p>{{ $user->description }}</p>
            </div>
            @endif
            
            @can('update', $user)
            <script type="text/javascript" src="{{ asset('/js/invitesManagement.js') }}" ></script>
            @include('partials.invitesListModal', ['user' => $user])
            <a class="btn btn-secondary my-2" type="button" data-bs-toggle="modal" href="#invites">View Invites</a>
            <a class="btn btn-secondary my-2" href='{{ route("updateUserForm", ["user_id" => $user->id]) }}'>Edit Profile</a>
            @endcan
            @can('delete', $user)
            <form method='post' action='{{ route("deleteUser", ["user_id" => $user->id]) }}'>
                {{ method_field('DELETE') }}
                {{ csrf_field() }}
                <button type="submit" class="btn btn-danger my-2">
                    Delete account
                </button>
            </form>
            @endcan

            @if (!is_null(Auth::user()->block_motive))
                <script type="text/javascript" src="{{ asset('/js/unblockAppealManagement.js') }}" ></script>
                <div class="my-4">
                    <h3>Block Motive</h3>
                    <p>{{ $user->block_motive }}</p>
                </div>
                @include('partials.sendUnblockAppealModal')
                @if (is_null(App\Models\UnblockAppeal::where('user_id', Auth::user()->id)->first()))    <!-- TODO: Find better way to do this, maybe in controller -->
                    <a id="unblockAppealModalButton" class="btn btn-secondary my-2" type="button" data-bs-toggle="modal" href="#sendUnblockAppealModal">Send Unblock Appeal</a>
                @else
                    <a id="unblockAppealModalButton" class="btn btn-success my-2" type="button">Unblock Appeal Sent</a>
                @endif
            @endif
        </div>
    </div>
   
    <div class="row my-5">
        <div class="col">
            <h2 class="display-4">Hosting</h2>
            <div class="row">
                @if($user->hosting()->exists())
                @each('partials.eventCard', $user->hosting()->orderBy('realization_date', 'DESC')->get(), 'event')
                @else
                <h3 class="display-6">None</h3>
                @endif
            </div>
        </div>
    </div>

    <div class="row my-5">
        <h2 class="display-4">Attending</h2>
        @if($user->attending()->exists())
        @each('partials.eventCard', $user->attending()->orderBy('realization_date', 'DESC')->get(), 'event')
        @else
        <h3 class="display-6">None</h3>
        @endif
    </div>
</div>
@endsection