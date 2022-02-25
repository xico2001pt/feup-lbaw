<div id="unblockAppealUser{{ $unblockAppeal->user_id }}" class="card my-2 w-100">
  <div class="card-body d-flex align-items-center">
    <img class="img-fluid rounded-circle me-3" style="height:3em;" src="{{ route('userImage', ['user_id' => $unblockAppeal->user_id]) }}">
    <a type="button" class="btn btn-secondary me-3" href="{{ url('user/' . $unblockAppeal->user_id) }}">{{ $unblockAppeal->user()->first()->username }}</a>
    <a type="button" class="btn btn-danger me-3" id="unblockButtonUser{{ $unblockAppeal->user_id }}" onclick="unblockUser2({{ $unblockAppeal->user_id }})">Unblock</a>
    <span class="ms-auto me-3">{{ $unblockAppeal->message }}</span>
  </div>
</div>