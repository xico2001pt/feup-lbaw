<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CommentReport extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'comment_report';

  /**
   * User who was reported
   */
  public function report() {
    return $this->belongsTo('App\Models\Report');
  }

  /**
   * Comment that was reported
   */
  public function target() {
    return $this->belongsTo('App\Models\Comment');
  }
}