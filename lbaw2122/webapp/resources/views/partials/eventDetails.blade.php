<!-- Access -->
<div class="mb-2">
<span class="card-text">
    <i class="bi bi-box-arrow-up" style="font-size: 1.5rem"></i>
    {{ $event->is_accessible ? 'Public' : 'Private' }}
</span>
</div>
<!-- Visibility -->
<div class="mb-2">
<span class="card-text">
    <i class="bi bi-eye" style="font-size: 1.5rem"></i>
    {{ $event->is_visible ? 'Public' : 'Private' }}
</span>
</div>
<!-- Date -->
<div class="mb-2">
<span class="card-text">
    <i class="bi bi-calendar-check" style="font-size: 1.5rem"></i>
    {{ $event->realization_date }}
</span>
</div>
<!-- Location -->
<div class="mb-2">
<span class="card-text">
    <i class="bi bi-compass" style="font-size: 1.5rem"></i>
    {{ $event->location }}
</span>
</div>
<!-- Price -->
<div>
<span class="card-text">
    <i class="bi bi-tag" style="font-size: 1.5rem"></i>
    {{ $event->price == 0.00 ? 'Free' : $event->price . '€' }}
</span>
</div>
<!-- Capacity -->
<div>
<span class="card-text">
    <i class="bi bi-person" style="font-size: 1.5rem"></i>
    @if($event->capacity)
        {{ $event->number_attendees . '/' . $event->capacity }}
        @if($event->number_attendees >= $event->capacity)
             (Sold-out)
        @endif
    @else
        {{ $event->number_attendees }}
    @endif
</span>
</div>