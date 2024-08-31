
return;
if (camera_mode == "@html5-v1") {
		
		var _cam_props_w = camera_props[$ "width"];
		var _cam_props_h = camera_props[$ "height"];
		var _cam_props_is_portrait = camera_props[$ "orientation_portrait"] == true;
		
		var _prop_width = _props.width;
		var _prop_height = _props.height;
		var _prop_orientation = _props.orientation;
		
		var _width;
		var _height;
		var _surf_width = undefined;
		var _surf_height = undefined;
		var _gui_width = undefined;
		var _gui_height = undefined;
		
		/// @debug
		if (is_desktop_native()) {
			_surf_width ??= _prop_width;
			_surf_height ??= _prop_height;
			
			if (_prop_orientation == "landscape") {
			
				if (_cam_props_is_portrait) {
					var _z = _prop_width;
				
					_prop_width = _prop_height;
					_prop_height = _z;
				}
			
			} else {
			
				if (!_cam_props_is_portrait) {
					var _z = _prop_width;
				
					_prop_width = _prop_height;
					_prop_height = _z;
				}
			}
		}
		
		if (is_numeric(_cam_props_w) && is_undefined(_cam_props_h)) {
			var _size = winadaptive_calculate_by_width({
				width: _prop_width,
				height: _prop_height,
			}, _cam_props_w);
			
			_width = _size.width;
			_height = _size.height;
		} else if (is_numeric(_cam_props_h) && is_undefined(_cam_props_w)) {
			var _size = winadaptive_calculate_by_height({
				width: _prop_width,
				height: _prop_height,
			}, _cam_props_h);
			
			_width = _size.width;
			_height = _size.height;
		} else if (is_numeric(_cam_props_h) && is_numeric(_cam_props_w)) {
			var _size = winadaptive_calculate({
				width: _prop_width,
				height: _prop_height,
			}, {
				width: _cam_props_w,
				height: _cam_props_h,
			});
			
			_width = _size.max.width;
			_height = _size.max.height;
		} else {
			_width = _prop_width;
			_height = _prop_height;
		}
		
		if (is_desktop_native()) {
			_surf_width ??= _prop_width;
			_surf_height ??= _prop_height;
		}
	
		if (is_mobile_browser()) {
			var _size = winadaptive_calculate({
				width: _prop_width,
				height: _prop_height,
			}, {
				width: _cam_props_w,
				height: _cam_props_h,
			});
			
			_surf_width ??= _size.min.width;
			_surf_height ??= _size.min.height;
			_gui_width ??= _size.min.width;
			_gui_height ??= _size.min.height;
		}
		
		if (MACRO_FLAG_IS_DEBUG) {
			show_debug_message({
				emitter: "o_game_service_camera",
				cause: "resize",
				width: _width,
				height: _height,
			});
		}
		
		/* if we inject custom style to page, then need update window 
		 * In this case, changing the window is equivalent to changing 
		 * the canvas size, which will not cause the engine to trigger 
		 * events about changing the window size. Thus, there should 
		 * be a function for changing the canvas size, not the window, 
		 * which is not the same thing within Game Maker.
		 *
		 * TODO: rename window_set_size to html_resize_canvas
		 */
		if (_props.is_browser) {
			var _is_active_fullscreen_extension = extension_exists("e_module_html_fullscreen");
			
			if (_is_active_fullscreen_extension) {
				html_fullscreen_custom(_width, _height); // resize canvas
				
				if (MACRO_FLAG_IS_DEBUG) {
					show_debug_message({
						emitter: "o_game_service_camera",
						cause: "e_module_html_fullscreen",
						text: "Again resize window for e_module_html_fullscreen extension",
						width: _width,
						height: _height,
					});
				}
			} else {
				/// for html5 this function - html_resize_canvas
				window_set_size(_width, _height);
			}
		}
		
		/*
		 * The game is oriented to HTML5 (for running in browser on any os)
		 *
		 * Other platform for only debug
		 */
		/// @debug
		if (MACRO_FLAG_IS_DEBUG) {
			if (os_type == os_windows && os_browser == browser_not_a_browser) {
				if (!variable_instance_exists(self, "debug_window_first_resize")) {
					self.debug_window_first_resize = true;
					
					var _size = winadaptive_calculate({
						width: _width,
						height: _height,
					}, {
						width: 640,
						height: 480,	
					});
					
					var _window = winadaptive_calculate_inscribed_rectangle({
						width: _size.min.width,
						height: _size.min.height,
					}, {
						width: display_get_width() * 0.8,
						height: display_get_height() * 0.8
					});
					
					window_set_position(160, 160);
					window_set_min_width(_size.min.width);
					window_set_min_height(_size.min.height);
					window_set_size(_window.width, _window.height);
					
					show_debug_message({
						emitter: "o_game_service_camera",
						cause: "@windows :: e_module_html_fullscreen:window",
						text: "resize windows",
						width: _size.min.width,
						height: _size.min.height,
						t_width: _window.width,
						t_height: _window.height,
					});
				}
			}
		}
		
		_surf_width ??= _width;
		_surf_height ??= _height;
		_gui_width ??= _surf_width;
		_gui_height ??= _surf_height;
		
		if (MACRO_FLAG_IS_DEBUG) {
			show_debug_message({
				emitter: "o_game_service_camera",
				cause: "e_module_html_fullscreen:surface",
				text: "GUI and APP_SURF size",
				width: _surf_width,
				height: _surf_height,
				gui_width: _gui_width,
				gui_height: _gui_height,
			});
		}
		
		/* application surface */
		if (application_surface_is_enabled()) {
			surface_resize(application_surface, _surf_width, _surf_height);	
		}
		
		/* display gui */
		display_set_gui_size(_gui_width, _gui_height);
		
		/* camera update */
		camera_base_w = _width;
		camera_base_h = _height;
		
		camera_set_view_size(camera, _width, _height);
		
		/* actions */
		
		self.bind_camera_for_view();
		self.emit_update_camera_size();
		
		return;
	}
	