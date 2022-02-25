<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserReport extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'user_report';

  /**
   * User who was reported
   */
  public function report() {
    return $this->belongsTo('App\Models\Report');
  }

  /**
   * User who was reported
   */
  public function target() {
    return $this->belongsTo('App\Models\User');
  }
}