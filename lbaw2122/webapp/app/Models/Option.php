<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Option extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'option';

  /**
   * The poll this option belongs to
   */
  public function poll() {
    return $this->belongsTo('App\Models\Poll');
  }

  /**
   * The users that voted in this option
   */
  public function voters() {
    return $this->hasMany('App\Models\User');
  }
}
