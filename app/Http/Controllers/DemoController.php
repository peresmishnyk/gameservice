<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DemoController extends Controller
{
    /**
     * Display the faceted search demo page.
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        // For now, we'll just return a view.
        // Data for the faceted search will be added later.
        return view('demo.index');
    }
}
