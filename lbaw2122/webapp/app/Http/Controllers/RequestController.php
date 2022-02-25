<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Event;
use App\Models\Request;
use App\Notifications\RequestAccepted;
use App\Notifications\RequestDenied;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class RequestController extends Controller
{
    /**
     * Sends a request to enter the event
     */
    public function send($event_id) {
        if (!Auth::check()) return response(null, 401);
        $user = Auth::user();
        $request = new Request;
        $request->user_id = $user->id;
        $request->event_id = $event_id;
        $request->save();
        return response(null, 200);
    }

    /**
     * Accepts a request
     */
    public function accept($request_id) {
        $request = Request::find($request_id);
        $this->authorize('update', $request);
        if(!$request->accepted && $request->event()->first()->isNotFull()){
            $request->accepted = TRUE;
            $request->save();
            $request->event()->first()->attendees()->attach($request->requester);
            $request->requester()->first()->notify(new RequestAccepted($request));
        }
        return response(null, 200);
    }

    /**
     * Rejects a request
     */
    public function reject($request_id) {
        $request = Request::find($request_id);
        $this->authorize('delete', $request);
        $request->requester()->first()->notify(new RequestDenied($request));
        $request->delete();
        return response(null, 200);
    }
}
