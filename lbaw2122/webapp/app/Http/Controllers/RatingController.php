<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Models\Rating;
use App\Models\Comment;
use Illuminate\Http\Request;

class RatingController extends Controller
{
    private function getRating($input) {
        return $input == 'true' ? 'Upvote' : 'Downvote';
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    private function store(Request $request, $commentId)
    {
        $comment = Comment::find($commentId);

        $rating = new Rating();
        $rating->comment_id = $commentId;
        $rating->user_id = Auth::user()->id;
        $rating->vote = $this->getRating($request->input('rating'));

        $rating->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Rating  $rating
     * @return \Illuminate\Http\Response
     */
    private function destroy(Rating $rating)
    {
        $rating->delete();
    }

    public function addRating(Request $request, $commentId)
    {
        if (!Auth::check() || !$request->has('rating')) return;
        
        $comment = Comment::find($commentId);
        $this->authorize('ratingComment', $comment);

        $rating = Rating::where('user_id', '=', Auth::user()->id)->where('comment_id', '=', $commentId)->first();
        if ($rating) {
            $this->destroy($rating);
            if ($this->getRating($request->input('rating')) != $rating->vote)
                $this->store($request, $commentId);
        } else
            $this->store($request, $commentId);
    }
}
