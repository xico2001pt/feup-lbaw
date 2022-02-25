<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UnblockAppeal extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'unblock_appeal';

  /**
   * The user this card belongs to
   */
  public function user() {
    return $this->belongsTo('App\Models\User');
  }
}
