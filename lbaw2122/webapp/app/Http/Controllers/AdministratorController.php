<?php

namespace App\Http\Controllers;

use App\Models\Administrator;
use App\Models\User;
use App\Models\UnblockAppeal;
use App\Http\Requests\BlockMessageCreateRequest;
use App\Http\Requests\ContactUsRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Notification;
use Illuminate\Http\Request;
use App\Notifications\Contact;

class AdministratorController extends Controller
{
    public function home()
    {
        if(Auth::check()) {
            return view('pages.admin');
        }
        return redirect('/login');
    }

    public function users(Request $request)
    {
        if($request->has('username') && $request->input('username') != ''){
            $users = User::where('username', $request->input('username'))->paginate(1);
        } else {
            $users = User::where('is_admin', false)->orderBy('username')->paginate(24);
        }
        return view('pages.adminUserList', ['users' => $users]);
    }

    public function blockUser(BlockMessageCreateRequest $request, $id)
    {
        $user = User::find($id);
        $motive = $request->input('block_motive');
        $user->block_motive = $motive;
        $user->save();
        return response(null, 200);
    }

    public function unblockUser(Request $request, $id){
        $user = User::find($id);
        $user->block_motive = null;
        $user->save();
        $user->unblockAppeal()->delete();
        return response(null, 200);
    }

    public function contact(ContactUsRequest $request){
        $admins = User::where('is_admin', 'true')->get();
        Notification::send($admins, new Contact($request->input('name'), $request->input('email'), $request->input('message')));
        return redirect('/');
    }

    public function unblockAppeals(Request $request) {
        return view('pages.adminUnblockAppealList', ['unblockAppeals' => UnblockAppeal::all()]);
    }
}
