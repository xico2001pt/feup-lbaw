<?php

namespace App\Policies;

use App\Models\Event;
use App\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Support\Facades\Auth;

class EventPolicy
{
    use HandlesAuthorization;

    public static function isHost(User $user, Event $event)
    {
        return $event->host()->first()->id === $user->id;
    }

    public static function isAttendee(User $user, Event $event)
    {
        return $user->attending()->get()->contains($event);
    }

    private function participatingInEvent(User $user, Event $event)
    {
        return $this->isHost($user,$event) || $this->isAttendee($user,$event);
    }

    public static function isAdmin(User $user) {
        return $user->is_admin;
    }

    /**
     * Determine whether the user can view the event content (comments/polls).
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Event  $event
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function viewContent(User $user, Event $event)
    {
        return ($this->participatingInEvent($user, $event) && is_null($user->block_motive)) || $this->isAdmin($user);
    }

    public function host(User $user, Event $event){
        return $event->host()->first()->id === $user->id && is_null($user->block_motive);
    }

    public function viewInformation(?User $user, Event $event){
        if($event->is_visible){
            return true;
        }
        if($user === null){
            return false;
        }
        return $this->participatingInEvent($user, $event) || $this->isAdmin($user);
    }

    public function invite(User $inviter, User $invitee, Event $event){
        return $this->participatingInEvent($inviter, $event) && !($this->participatingInEvent($invitee, $event));
    }

    /**
     * Determine whether the user can create models.
     *
     * @param  \App\Models\User  $user
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function create(User $user)
    {
        return !$this->isAdmin($user) && is_null($user->block_motive);
    }

    /**
     * Determine whether the user can update the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Event  $event
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function update(User $user, Event $event)
    {
        return ($this->isHost($user, $event) && is_null($user->block_motive)) || $this->isAdmin($user);
    }

    public function join(?User $user, Event $event) 
    {
        if (is_null($user)) return $event->is_accessible && $event->isNotFull() && $event->realization_date->isFuture();
        else return $event->is_accessible &&
                    $event->isNotFull() &&
                    $event->realization_date->isFuture() &&
                    !($this->participatingInEvent($user, $event)) &&
                    !($this->isAdmin($user)) &&
                    is_null($user->block_motive);
    }

    public function request(?User $user, Event $event) 
    {
        if (is_null($user)) return !$event->is_accessible && $event->isNotFull() && $event->realization_date->isFuture();
        else return !$event->is_accessible &&
                    $event->isNotFull() &&
                    $event->realization_date->isFuture() &&
                    !($this->participatingInEvent($user, $event)) &&
                    !($this->isAdmin($user)) &&
                    is_null($user->block_motive);
    }

    public function leave(User $user, Event $event){
        return $this->isAttendee($user, $event) && is_null($user->block_motive);
    }

    /**
     * Determine whether the user can delete the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Event  $event
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function delete(User $user, Event $event)
    {
        return ($this->isHost($user, $event) && is_null($user->block_motive)) || $this->isAdmin($user);
    }

    /**
     * Determine whether the user can restore the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Event  $event
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function restore(User $user, Event $event)
    {
        //
    }

    /**
     * Determine whether the user can permanently delete the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Event  $event
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function forceDelete(User $user, Event $event)
    {
        //
    }

    public function createPost(User $user, Event $event)
    {
        return Auth::check() && $this->isHost($user, $event);
    }

    public function editPost(User $user, Event $event)
    {
        return Auth::check() && $this->isHost($user, $event);
    }

    public function deletePost(User $user, Event $event)
    {
        return Auth::check() && ($this->isHost($user, $event) || $this->isAdmin($user));
    }

    public function createComment(User $user, Event $event)
    {
        return Auth::check() && !$this->isAdmin($user) && $this->participatingInEvent($user, $event);
    }
}
