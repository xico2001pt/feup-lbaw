<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EventReport extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'event_report';

  /**
   * User who was reported
   */
  public function report() {
    return $this->belongsTo('App\Models\Report');
  }

  /**
   * Event that was reported
   */
  public function target() {
    return $this->belongsTo('App\Models\Event');
  }
}