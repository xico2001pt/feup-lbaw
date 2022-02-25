<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Attendee extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'attendee';

  /**
   * User 
   */
  public function user() {
    return $this->belongsTo('App\Models\User');
  }

  /**
   * Event
   */
  public function event() {
    return $this->belongsTo('App\Models\Event');
  }
}
