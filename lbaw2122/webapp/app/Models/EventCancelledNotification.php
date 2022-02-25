<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EventCancelledNotification extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'event_cancelled_notification';

  protected $dates = [
    'notification_date',
  ];

  /**
   * Users affected by notification
   */
  public function users() {
    return $this->belongsToMany('App\Models\User');
  }
}
