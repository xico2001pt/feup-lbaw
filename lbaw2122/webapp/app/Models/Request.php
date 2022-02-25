<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Request extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'request';

  /**
   * User who made the request
   */
  public function requester() {
    return $this->belongsTo('App\Models\User', 'user_id');
  }

  /**
   * Event from which the request was made
   */
  public function event(){
    return $this->belongsTo('App\Models\Event');
  }
}
