@extends('layouts.adminBase')

@section('title', 'Eventful - Unblock Appeals Management')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('admin') }}">Admin</a></li>
<li class="breadcrumb-item active" aria-current="page">Unblock Appeals Management</li>
@endsection

@section('content')
<script type="text/javascript" src="{{ asset('/js/administration.js') }}" ></script>
<div class="container mt-5">
    <div class="jumbotron text-center mb-5">
        <h1 class="display-2">Unblock Appeals Management</h1>
    </div>
    <div class="column">
        @each('partials.adminUnblockAppealCard', $unblockAppeals, 'unblockAppeal')
    </div>
</div>
@endsection