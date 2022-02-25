<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\RegisterOAuthRequest;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;
use App\Models\User;

class GoogleOAuthController extends Controller
{
    use AuthenticatesUsers;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/events';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    /**
     * Redirect the user to the Google authentication page.
    *
    * @return \Illuminate\Http\Response
    */
    public function redirectToProvider()
    {
        return Socialite::driver('google')->redirect();
    }

    /**
     * Obtain the user information from Google.
     *
     * @return \Illuminate\Http\Response
     */
    public function handleProviderCallback()
    {
        $googleUser = Socialite::driver('google')->user();

        $user = User::where('google_id', $googleUser->id)->first();

        if ($user) {
            $user->update([
                'google_token' => $googleUser->token,
                'google_refresh_token' => $googleUser->refreshToken,
            ]);
            Auth::login($user);
            return redirect('/events');
        } else {
            session([
                'name' => $googleUser->name,
                'email' => $googleUser->email,
                'google_id' => $googleUser->id,
                'google_token' => $googleUser->token,
                'google_refresh_token' => $googleUser->refreshToken
            ]);
            return redirect('/google/registerOAuth');
        }
    }

    
    public function showRegistrationForm(){
        return view('auth.registerOAuth');
    }

    public function register(RegisterOAuthRequest $request)
    {
        if (!$request->session()->exists('name') ||
            !$request->session()->exists('email') ||
            !$request->session()->exists('google_id') ||
            !$request->session()->exists('google_token') ||
            !$request->session()->exists('google_refresh_token')) return redirect('/login');

        $user = User::create([
            'username' => $request->input('username'),
            'email' => $request->session()->pull('email'),
            'profile_pic' => 'profile_pictures/default.png',
            'name' => $request->session()->pull('name'),
            'birthdate' => $request->input('birthdate'),
            'google_id' => $request->session()->pull('google_id'),
            'google_token' => $request->session()->pull('google_token'),
            'google_refresh_token' => $request->session()->pull('google_refresh_token')
        ]);

        Auth::login($user);

        return redirect('user/' . $user->id);
    }
}
