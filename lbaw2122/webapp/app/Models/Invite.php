<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Invite extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'invite';

  /**
   * User who made the invite
   */
  public function inviter() {
    return $this->belongsTo('App\Models\User');
  }

  /**
   * Invited user
   */
  public function invitee(){
    return $this->belongsTo('App\Models\User');
  }

  /**
   * Event to which the invite was made
   */
  public function event(){
    return $this->belongsTo('App\Models\Event');
  }
}
