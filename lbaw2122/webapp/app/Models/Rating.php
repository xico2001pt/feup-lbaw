<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rating extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'rating';

  /**
   * Comment the rating belongs to
   */
  public function comment() {
    return $this->belongsTo('App\Models\Comment');
  }

  /**
   * User who made the rating
   */
  public function rater(){
    return $this->belongsTo('App\Models\User');
  }
}
