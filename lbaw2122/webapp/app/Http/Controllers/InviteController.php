<?php

namespace App\Http\Controllers;

use App\Models\Invite;
use Illuminate\Http\Request;

class InviteController extends Controller
{
    /**
     * Accepts an invite by updating accept boolean of invite to true
     */
    public function accept($invite_id) {
        $invite = Invite::find($invite_id);
        $this->authorize('update', $invite);
        $invite->accepted = TRUE;
        $invite->save();
        $event = $invite->event()->first();
        if ($event->is_accessible) {
            $this->authorize('join', $event);
            app('App\Http\Controllers\EventController')->join($invite->event_id);
        } else {
            app('App\Http\Controllers\RequestController')->send($invite->event_id);
        }
        return response(null, 200);
    }

    /**
     * Rejects an invite by removing it from the database
     */
    public function reject($invite_id) {
        $invite = Invite::find($invite_id);
        $this->authorize('delete', $invite);
        $invite->delete();
        return response(null, 200);
    }
}
