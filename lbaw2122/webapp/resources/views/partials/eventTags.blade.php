<div class="mb-2">
    @foreach($tags as $tag)
    <span class="badge badge-pill badge-primary bg-secondary">{{ $tag->name }}</span>
    @endforeach
</div>