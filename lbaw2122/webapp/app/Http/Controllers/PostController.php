<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Event;
use Illuminate\Support\Facades\View;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class PostController extends Controller
{
    // TODO: Better documentation
    private function getTextLengthFromDelta($text){
        $delta = json_decode($text);
        $text_length = 0;
        foreach($delta->{'ops'} as $op){ // Add up all the strlens in the text (delta format)
            if(property_exists($op, 'insert')){
                $text_length += strlen($op->{'insert'});
            }
        }
        return $text_length;
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request, $event_id)
    {
        if (!Auth::check()) return redirect('/login');
        $event = Event::find($event_id);
        $this->authorize('createPost', $event);

        $request->validate([
            'text' => 'required',
            ]);
        if($this->getTextLengthFromDelta($request->input('text')) > 8196){
            return response(null, 302); // TODO: Document this or is it unecessary?
        }

        $post = new Post();
        $post->text = $request->input('text');
        $post->event_id = $event->id;
        $post->save();

        $this->authorize('viewContent', $event);
        $view = View::make('pages.event', ['posts' => $event->posts()->get(), 'event' => $event]);
        $sections = $view->renderSections();
        return $sections['posts']; // TODO: Update on A7
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function show(Post $post)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $post_id)
    {
        if (!Auth::check()) return redirect('/login');

        $request->validate([
            'text' => 'required|max:16384',
            ]);
        if($this->getTextLengthFromDelta($request->input('text')) > 8196){
            return response(null, 302); // TODO: Document this or is it unecessary?
        }

        $post = Post::find($post_id);
        $this->authorize('editPost', $post->event()->first());
        $post->text = $request->input('text');
        $post->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Post  $post
     * @return \Illuminate\Http\Response
     */
    public function delete($post_id)
    {
        $post = Post::find($post_id);
        $this->authorize('deletePost', $post->event()->first());
        $post = Post::destroy($post_id);
        return response(null, 200);
    }
}
