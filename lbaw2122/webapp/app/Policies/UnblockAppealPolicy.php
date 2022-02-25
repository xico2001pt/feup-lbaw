<?php

namespace App\Policies;

use App\Models\UnblockAppeal;
use App\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class UnblockAppealPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can view the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\UnblockAppeal  $unblockAppeal
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function view(User $user, UnblockAppeal $unblockAppeal)
    {
        //
    }

    /**
     * Determine whether the user can create models.
     *
     * @param  \App\Models\User  $user
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function create(User $user)
    {
        return !is_null($user->block_motive) && is_null(UnblockAppeal::where('user_id', $user->id)->first());
    }

    /**
     * Determine whether the user can delete the model.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\UnblockAppeal  $unblockAppeal
     * @return \Illuminate\Auth\Access\Response|bool
     */
    public function delete(User $user, UnblockAppeal $unblockAppeal)
    {
        //
    }
}
