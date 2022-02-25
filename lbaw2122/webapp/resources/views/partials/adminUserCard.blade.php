<div class="col-auto mb-3 userCardCol" id="userCard{{ $user->id }}">
    <div class="rounded-lg shadow card @if($user->block_motive!=null) border-secondary border-1 @endif" style="width: 26rem; box-sizing: border-box;">
        <img class="card-img-top" src='{{ url("/user/$user->id" . "/profile_pic") }}' alt="Profile Picture">
        <div class="card-body">
            <h5 class="card-title">{{ $user->username }}</h5>
            <h6 class="card-subtitle mb-2 text-muted">{{ $user->name }}</h6>
            <div>
                <span class="class-text">
                    <i class="bi bi-envelope"></i>
                    {{ $user->email }}
                </span>
            </div>
            <div>
                <span class="class-text">
                    <i class="bi bi-calendar"></i>
                    {{ $user->birthdate }}
                </span>
            </div>
        </div>
        <div class="card-footer">
            <a type="button" class="btn btn-outline-primary" href="{{ url('/user/' . $user->id) }}">Profile</a>
            <a type="button" class="btn btn-outline-success" href="{{ route('updateUserForm', ['user_id' => $user->id]) }}">Edit</a>
            <a class="btn btn-outline-danger" onclick="deleteUser({{ $user->id }})">Delete</a>
            @if($user->block_motive == null)
            <a type="button" class="btn btn-outline-secondary" id="blockButtonUser{{ $user->id }}" data-bs-toggle="modal" data-bs-target="#blockUser{{ $user->id }}Modal">Block</a>
            @else
            <a type="button" class="btn btn-secondary" id="blockButtonUser{{ $user->id }}" onclick="unblockUser1({{ $user->id }})">Unblock</a>
            @endif
        </div>
    </div>
</div>