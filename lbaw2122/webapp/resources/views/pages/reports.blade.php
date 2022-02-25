@extends('layouts.adminBase')

@section('title', 'Eventful - Reports')

@section('breadcrumbs')
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('homepage') }}">Home</a></li>
<li class="breadcrumb-item" aria-current="page"><a href="{{ route('admin') }}">Admin</a></li>
<li class="breadcrumb-item active" aria-current="page">Report</li>
@endsection

@section('content')

<div class="container mt-5">
    <div class="jumbotron text-center">
        <h1 class="display-2">Reports</h1>    
    </div>
</div>

@endsection
