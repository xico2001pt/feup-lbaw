<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TagEvent extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'event_tag';

  /**
   * Tag
   */
  public function tag() {
    return $this->belongsTo('App\Models\Tag');
  }

  /**
   * Event
   */
  public function event(){
    return $this->belongsTo('App\Models\Event');
  }
}
