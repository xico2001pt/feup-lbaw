<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class EventUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'title' => 'nullable|string|min:1|max:255',
            'event_image' => 'nullable|mimes:jpeg,png,jpg,gif,svg|dimensions:min_width=100,min_height=100',
            'description' => 'nullable|string|min:1|max:8192',
            'location' => 'nullable|string|min:1|max:255',
            'realization_date' => 'nullable|date|after:today',
            'visibility' => 'nullable|string',
            'access' => 'nullable|string',
            'capacity' => 'nullable|integer|min:0',
            'price' => 'nullable|numeric|between:0,999999.99'
        ];
    }
}
