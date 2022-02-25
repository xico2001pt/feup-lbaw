<?php

namespace App\Http\Controllers;

use App\Models\File;
use App\Models\Comment;
use App\Models\Event;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Storage;

class FileController extends Controller
{
    public function getDownload($file_id) {
        $file = File::find($file_id);
        $comment = Comment::find($file->comment_id);
        $event = Event::find($comment->event_id);
        $this->authorize('viewContent' ,$event);
        return Storage::download($file->path, $file->original_name);
    }
}
