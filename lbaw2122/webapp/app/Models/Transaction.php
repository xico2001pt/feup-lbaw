<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'transaction';

  /**
   * User who made the transaction
   */
  public function author() {
    return $this->belongsTo('App\Models\User');
  }
}
