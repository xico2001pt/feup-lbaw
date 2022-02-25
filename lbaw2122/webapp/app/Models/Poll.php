<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Poll extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'poll';

  /**
   * The post this poll belongs to
   */
  public function post() {
    return $this->belongsTo('App\Models\Post');
  }

  /**
   * The options this poll is associated to
   */
  public function options() {
    return $this->hasMany('App\Models\Option');
  }
}
