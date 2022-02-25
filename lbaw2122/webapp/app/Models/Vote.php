<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vote extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'vote';

  /**
   * Users that voted in the option
   */
  public function user() {
    return $this->belongsTo('App\Models\User');
  }

  /**
   * Option that the user voted in
   */
  public function option() {
    return $this->belongsTo('App\Models\Option');
  }
}
