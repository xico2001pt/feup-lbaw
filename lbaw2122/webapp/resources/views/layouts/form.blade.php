@extends('layouts.base')

@section('content')
<div class="row justify-content-center">
    <div class="d-flex mt-5 justify-content-center">
        <div class="card w-50">
            <div class="card-header">@yield('form-title')</div>
            <div class="card-body">@yield('form-content')</div>
        </div>
    </div>
</div>
@endsection
