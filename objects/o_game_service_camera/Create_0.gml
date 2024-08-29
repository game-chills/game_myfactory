
/* EVENT:LIST */
/*
	camera.bind ({ 
		base_w,
		base_h,
	})
	camera.resize ({ 
		base_w,
		base_h,
	})
*/

/* params */

camera_mode = "@html5-v1"; // "@html5-v1"
camera_props = {
	//width: 1080,
	height: 1920,
	orientation_portrait: true,
}

/* state */

view_index = 0;

camera = camera_create_view(0, 0, 1, 1);
camera_scale = 1;
camera_base_w = 1;
camera_base_h = 1;

tracking_room = room;

/* methods */

/// for set camera in view
bind_camera_for_view = function() {
	view_enabled = true;
	
	view_visible[view_index] = true;
	view_wport[view_index] = camera_base_w;
	view_hport[view_index] = camera_base_h;
	
	if (view_camera[view_index] != camera) {
		var _previous_camera = view_camera[view_index];
		
		view_camera[view_index] = camera;
		
		camera_destroy(_previous_camera);
		
		self.emit_update_view_camera();
	}
}

/// notifies
emit_update_view_camera = function() {
	GlobalEventEmitter("camera").emit("bind", {
		base_w: camera_base_w,
		base_h: camera_base_h,
	});
}

emit_update_camera_size = function() {
	GlobalEventEmitter("camera").emit("resize", {
		base_w: camera_base_w,
		base_h: camera_base_h,
	});
}

/// getters camera props
get_x = function() {
	return camera_get_view_x(camera);
}

get_y = function() {
	return camera_get_view_y(camera);
}

get_w = function() {
	return camera_get_view_width(camera);
}

get_h = function() {
	return camera_get_view_height(camera);
}

get_base_w = function() {
	return camera_base_w;
}

get_base_h = function() {
	return camera_base_h;
}

get_xcenter = function() {
	var _width = camera_get_view_width(camera);
	return camera_get_view_x(camera) + _width / 2;
}

get_ycenter = function() {
	var _height = camera_get_view_height(camera);
	return camera_get_view_y(camera) + _height / 2;
}

get_xangle = function() {
	var _angle = camera_get_view_angle(camera);
	var _width = camera_get_view_width(camera);
	var _height = camera_get_view_height(camera);
	
	var _xcenter = camera_get_view_x(camera) + _width / 2;
	var _ycenter = camera_get_view_y(camera) + _height / 2;

	return _xcenter - (
		lengthdir_x(_width / 2, -_angle) - lengthdir_x(_height / 2, -_angle + 90)
	)
}

get_yangle = function() {
	var _angle = camera_get_view_angle(camera);
	var _width = camera_get_view_width(camera);
	var _height = camera_get_view_height(camera);
	
	var _xcenter = camera_get_view_x(camera) + _width / 2;
	var _ycenter = camera_get_view_y(camera) + _height / 2;
	
	return _ycenter - (
		lengthdir_y(_width / 2, -_angle) - lengthdir_y(_height / 2, -_angle + 90)
	)
}

get_world_pos = function(_props) {
	var _xocf = 0.5 - _props.xcf;
	var _yocf = 0.5 - _props.ycf;
	
	var _angle = camera_get_view_angle(camera);
	var _width = camera_get_view_width(camera);
	var _height = camera_get_view_height(camera);
	
	var _xcenter = camera_get_view_x(camera) + _width / 2;
	var _ycenter = camera_get_view_y(camera) + _height / 2;
	
	var _xworld = _xcenter - (
		lengthdir_x(_width * _xocf, -_angle) - lengthdir_x(_height * _yocf, -_angle + 90)
	);
	var _yworld = _ycenter - (
		lengthdir_y(_width * _xocf, -_angle) - lengthdir_y(_height * _yocf, -_angle + 90)
	);
	
	return {
		x_world: _xworld,
		y_world: _yworld,
	}
}

get_scale = function() {
	return camera_scale;	
}

get_angle = function() {
	return camera_get_view_angle(camera);
}

/// setters camera props
set_pos = function(_x, _y) {
	camera_set_view_pos(camera, _x, _y);
}

set_pos_by_center = function(_x, _y) {
	var _width = camera_get_view_width(camera);
	var _height = camera_get_view_height(camera);
	
	camera_set_view_pos(camera, _x - _width / 2, _y - _height / 2);
}

set_scale = function(_scale) {
	camera_scale = clamp(_scale, 0.1, 1000);
	
	var _xcenter = self.get_xcenter();
	var _ycenter = self.get_ycenter();
	
	camera_set_view_size(
		camera, 
		camera_base_w * camera_scale, 
		camera_base_h * camera_scale
	);
	
	self.set_pos_by_center(_xcenter, _ycenter);
}

set_angle = function(_angle) {
	camera_set_view_angle(camera, wrap(_angle, 360));
}

/* service providers */

GlobalService("camera").provider("get:x", get_x);
GlobalService("camera").provider("get:y", get_y);
GlobalService("camera").provider("get:w", get_w);
GlobalService("camera").provider("get:h", get_h);
GlobalService("camera").provider("get:base_w", get_base_w);
GlobalService("camera").provider("get:base_h", get_base_h);
GlobalService("camera").provider("get:xcenter", get_xcenter);
GlobalService("camera").provider("get:ycenter", get_ycenter);
GlobalService("camera").provider("get:xangle", get_xangle);
GlobalService("camera").provider("get:yangle", get_yangle);
GlobalService("camera").provider("get:world_pos", get_world_pos);
GlobalService("camera").provider("get:scale", get_scale);
GlobalService("camera").provider("get:angle", get_angle);

GlobalService("camera").provider("set:pos", function(_pos) {
	set_pos(_pos.x, _pos.y);	
});
GlobalService("camera").provider("set:pos_by_center", function(_pos) {
	set_pos_by_center(_pos.x, _pos.y);	
});
GlobalService("camera").provider("set:scale", set_scale);
GlobalService("camera").provider("set:angle", set_angle);

/* subscriptions */

GlobalEventEmitter("window").on("change", function(_props) {
	
	#region @html5-v1
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
		
		if (is_desktop() && !is_browser()) {
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
			_width = _cam_props_w;
			_height = _prop_height / _prop_width * _cam_props_w;	
		} else if (is_numeric(_cam_props_h) && is_undefined(_cam_props_w)) {
			_height = _cam_props_h;
			_width = _prop_width / _prop_height * _cam_props_h;
		} else if (is_numeric(_cam_props_h) && is_numeric(_cam_props_w)) {
			
			var _w = _prop_width / _prop_height * _cam_props_h;
			var _h = _prop_height / _prop_width * _cam_props_w;
			
			var _v1_w = _cam_props_w;
			var _v1_h = _h;
			var _v1_square = _v1_w * _v1_h;
			
			var _v2_w = _w;
			var _v2_h = _cam_props_h;
			var _v2_square = _v2_w * _v2_h;
			
			if (_v1_square > _v2_square) {
				_width = _v1_w;
				_height = _v1_h;
			} else {
				_width = _v2_w;
				_height = _v2_h;
			}
			
		} else {
			_width = _prop_width;
			_height = _prop_height;
		}
		
		if (is_desktop()) {
			_surf_width ??= _prop_width;
			_surf_height ??= _prop_height;
		}
	
		if (is_browser() && is_mobile()) {
			var _w = _prop_width / _prop_height * _cam_props_h;
			var _h = _prop_height / _prop_width * _cam_props_w;
			
			var _v1_w = _cam_props_w;
			var _v1_h = _h;
			var _v1_square = _v1_w * _v1_h;
			
			var _v2_w = _w;
			var _v2_h = _cam_props_h;
			var _v2_square = _v2_w * _v2_h;
			
			if (_v1_square > _v2_square) {
				_surf_width ??= _v2_w;
				_surf_height ??= _v2_h;
			} else {
				_surf_width ??= _v1_w;
				_surf_height ??= _v1_h;
			}
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
		if (MACRO_FLAG_IS_DEBUG) {
			if (os_type == os_windows && os_browser == browser_not_a_browser) {
				if (!variable_instance_exists(self, "debug_window_first_resize")) {
					self.debug_window_first_resize = true;
					
					var _ww1 = 640;
					var _hh1 = _height / _width * _ww1;
					
					var _hh2 = 480;
					var _ww2 = _width / _height * _hh2;
					
					var _ww;
					var _hh;
					
					if (_ww1 * _hh1 > _ww2 * _hh2) {
						_ww = _ww2;
						_hh = _hh2;
					} else {
						_ww = _ww1;
						_hh = _hh1;
					}
					
					window_set_position(160, 160);
					window_set_min_width(_ww);
					window_set_min_height(_hh);
					
					var _min_scale = min(
						(display_get_width() * 0.8) / _ww,
						(display_get_height() * 0.8) / _hh
					);
					
					var _tw = _ww * _min_scale;
					var _th = _hh * _min_scale;
					window_set_size(_tw, _th);
					
					show_debug_message({
						emitter: "o_game_service_camera",
						cause: "@windows :: e_module_html_fullscreen:window",
						text: "resize windows",
						width: _ww,
						height: _hh,
						t_width: _tw,
						t_height: _th,
					});
				}
			}
		}
		
		_surf_width ??= _width;
		_surf_height ??= _height;
		
		if (MACRO_FLAG_IS_DEBUG) {
			show_debug_message({
				emitter: "o_game_service_camera",
				cause: "e_module_html_fullscreen:surface",
				text: "GUI and APP_SURF size",
				width: _surf_width,
				height: _surf_height,
			});
		}
		
		/* application surface */
		if (application_surface_is_enabled()) {
			surface_resize(application_surface, _surf_width, _surf_height);	
		}
		
		/* display gui */
		display_set_gui_size(_surf_width, _surf_height);
		
		/* camera update */
		camera_base_w = _width;
		camera_base_h = _height;
		
		camera_set_view_size(camera, _width, _height);
		
		/* actions */
		
		self.bind_camera_for_view();
		self.emit_update_camera_size();
		
		return;
	}
	#endregion
	
});

/* init */

self.bind_camera_for_view();
