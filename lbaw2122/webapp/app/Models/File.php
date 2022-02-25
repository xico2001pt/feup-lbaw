<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class File extends Model
{
  // Don't add create and update timestamps in database.
  public $timestamps  = false;
  protected $table = 'file';
  protected $primaryKey = 'file_id';

  /**
   * Comment the file is attached to
   */
  public function comment() {
    return $this->belongsTo('App\Models\Comment');
  }
}
