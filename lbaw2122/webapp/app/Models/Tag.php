<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tag extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'tag';

  /**
   * The events this tag is associated to
   */
  public function events() {
    return $this->belongsToMany('App\Models\Event');
  }
}
