<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class EventCreateRequest extends FormRequest
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
            'title' => 'required|string|min:1|max:255',
            'event_image' => 'mimes:jpeg,png,jpg,gif,svg|dimensions:min_width=100,min_height=100',
            'description' => 'required|string|min:1|max:8192',
            'location' => 'required|string|min:1|max:255',
            'realization_date' => 'required|date|after:today',
            'visibility' => 'required|string',
            'access' => 'required|string',
            'capacity' => 'required|integer|min:0',
            'price' => 'required|numeric|between:0,999999.99'
        ];
    }
}
