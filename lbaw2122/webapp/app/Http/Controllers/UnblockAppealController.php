<?php

namespace App\Http\Controllers;

use App\Models\UnblockAppeal;
use Illuminate\Http\Request;
use App\Http\Requests\UnblockAppealCreateRequest;
use Illuminate\Support\Facades\Auth;

class UnblockAppealController extends Controller
{
    public function create(UnblockAppealCreateRequest $request)
    {
        $this->authorize('create', App\Models\UnblockAppeal::class);

        $unblockAppeal = new UnblockAppeal;
        $unblockAppeal->user_id = Auth::user()->id;
        $unblockAppeal->message = $request->input('content');
        $unblockAppeal->save();

        return response(null, 200);
    }
}
