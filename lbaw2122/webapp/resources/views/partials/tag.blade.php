<div class="form-check">
    @if (!empty($selected) && in_array($tag->id, $selected))
        <input class="form-check-input" type="checkbox" id="{{ $tag->id }}" name="tag[]" value="{{ $tag->id }}" checked>
    @else
        <input class="form-check-input" type="checkbox" id="{{ $tag->id }}" name="tag[]" value="{{ $tag->id }}">
    @endif
    <label class="form-check-label" for="{{ $tag->id }}">{{ $tag->name }}</label>
</div>