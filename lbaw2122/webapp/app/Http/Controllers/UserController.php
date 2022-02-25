<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use App\Http\Requests\UserUpdateRequest;

class UserController extends Controller
{
    /**
     * Display the specified resource.
     *
     * @param  \App\Models\User  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $user = User::find($id);
        $this->authorize('view', $user);
        return view('pages.profile', ['user' => $user]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  $id
     * @return \Illuminate\Http\Response
     */
    public function showUpdateForm($id)
    {
        if (!Auth::check()) return redirect('/login');
        $user = User::find($id);
        $this->authorize('update', $user);
        return view('pages.updateProfile', ['user'=>$user]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\User  $user
     * @return \Illuminate\Http\Response
     */
    public function update(UserUpdateRequest $request, $id)
    {
        if (!Auth::check()) return redirect('/login');
        $user = User::find($id);
        $this->authorize('update', $user);

        $validated = $request->validated();

        if(!is_null($request->input('username'))){ 
            $user->username = $request->input('username');
        }
        
        if(!is_null($request->input('name'))){ 
            $user->name = $request->input('name');
        }
        
        if(!is_null($request->file('profile_pic'))){ 
            $user->profile_pic = $request->file('profile_pic')->store('profile_pictures');
            $image = Image::make(Storage::path($user->profile_pic))->fit(400,400); // TODO: Check if there's a better way to do this
            $image->save();
        }
        
        if(!is_null($request->input('description'))){ 
            $user->description = $request->input('description');
        }
        
        if(!is_null($request->input('email'))){ 
            $user->email = $request->input('email');
        }

        if(!is_null($request->input('password'))){ 
            $user->password = bcrypt($request->input('password'));
        }
        
        if(!is_null($request->input('birthdate'))){ 
            $user->birthdate = $request->input('birthdate');
        }

        $user->save();
        
        return redirect('user/' . $user->id);
    }

    public function getImage($id){
        $user = User::find($id);
        return Storage::response($user->profile_pic);
    }

    public function markNotificationAsRead($id, Request $request){
        $user = User::find($id);
        if(Auth::check() && Auth::id() == $id){
            $user->unreadNotifications()->find($request->input('notification_id'))->markAsRead();
        }
        return response(null, 200); // TODO: Idk what to return on error tbh...
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\User  $user
     * @return \Illuminate\Http\Response
     */
    public function delete($id)
    {
        $user = User::find($id);
        $this->authorize('delete', $user);
        DB::transaction(function () use ($id) {
            DB::statement('SELECT delete_user(?)', [$id]);
        }, 3);
        return redirect('/');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\User  $user
     * @return \Illuminate\Http\Response
     */
    public function deleteAPI($id)
    {
        $user = User::find($id);
        $this->authorize('delete', $user);
        DB::transaction(function () use ($id) {
            DB::statement('SELECT delete_user(?)', [$id]);
        }, 3);
        return response(null, 200);
    }
}
