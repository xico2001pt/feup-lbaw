<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'post';

  protected $dates = [
    'creation_date',
  ];

  /**
   * The event this post belongs to
   */
  public function event() {
    return $this->belongsTo('App\Models\Event');
  }
}
