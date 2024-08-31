
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

camera_mode = "@html5-v2"; // "@html5-v2"
camera_props = {
	width: 1080,
	height: 1920,
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
	
	#region @html5-v2
	if (camera_mode == "@html5-v2") {
		
		var _prop_is_browser = _props.env_is_browser;
		var _prop_is_desktop = _props.env_is_desktop;
		
		var _prop_window_width = _props.window_width;
		var _prop_window_height = _props.window_height;
		var _prop_window_orientation = _props.window_orientation;
		
		var _prop_display_width = _props.display_width;
		var _prop_display_height = _props.display_height;
		
		var _cam_props_w = camera_props[$ "width"];
		var _cam_props_h = camera_props[$ "height"];
		var _cam_props_orientation =
			_cam_props_w > _cam_props_h
			? "landscape"
			: "portrait"
		
		///
		
		var _type_os =
			_prop_is_desktop
			? "desktop"
			: "mobile";
		
		var _type_env =
			_prop_is_browser
			? "browser"
			: "native"
		
		var _type = string("{0}:{1}", _type_os, _type_env);
		
		/// @debug
		if (_type == "desktop:native") {
			
			var _is_first_call_for_this =
				!variable_instance_exists(id, "_/@html5-v2/desktop:native/first");
			
			variable_instance_set(id, "_/@html5-v2/desktop:native/first", true);
			
			if (_is_first_call_for_this) {
				
				var _window_size = winadaptive_calculate_inscribed_rectangle({
					width: _cam_props_w,
					height: _cam_props_h,
				}, {
					width: _prop_display_width * 0.8,
					height: _prop_display_height * 0.8,
				});
				var _size = winadaptive_calculate({
					width: _cam_props_w,
					height: _cam_props_h,
				}, {
					width: 640,
					height: 480,	
				});
				
				window_set_size(_window_size.width, _window_size.height);
				window_set_min_width(_size.min.width);
				window_set_min_height(_size.min.height);
				window_set_position(160, 160);
				
				_prop_window_width = _window_size.width;
				_prop_window_height = _window_size.height;
				
			}
			
			var _width = undefined;
			var _height = undefined;
			var _width_surface = undefined;
			var _height_surface = undefined;
			var _width_gui = undefined;
			var _height_gui = undefined;
			
			/// @calculate
			
			var _size_camera = winadaptive_calculate({
				width: _prop_window_width,
				height: _prop_window_height,
			}, {
				width: _cam_props_w,
				height: _cam_props_h,
			});
			
			_width = _size_camera.max.width;
			_height = _size_camera.max.height;
			_width_surface = _prop_window_width;
			_height_surface = _prop_window_height;
			_width_gui = _size_camera.max.width;
			_height_gui = _size_camera.max.height;
			
			/// @set
			
			/* application surface */
			if (application_surface_is_enabled()) {
				surface_resize(application_surface, _width_surface, _height_surface);	
			}
			
			/* display gui */
			display_set_gui_size(_width_gui, _height_gui);
			
			/* camera update */
			camera_base_w = _width;
			camera_base_h = _height;
		
			camera_set_view_size(camera, _width, _height);
		
			/* actions */
		
			self.bind_camera_for_view();
			self.emit_update_camera_size();
			
			return;
		}
		
		/// @unsupported
		if (_type == "mobile:native") {
		
			throw new Error("[o_game_service_camera]:@html5-v2 `mobile:native` not implemented");
		
			return;
		}
		
		/// @supported
		if (
			_type == "desktop:browser" ||
			_type == "mobile:browser"
		) {
			var _width = undefined;
			var _height = undefined;
			var _width_surface = undefined;
			var _height_surface = undefined;
			var _width_gui = undefined;
			var _height_gui = undefined;
			
			/// @calculate
			
			var _size_camera = winadaptive_calculate({
				width: _prop_window_width,
				height: _prop_window_height,
			}, {
				width: _cam_props_w,
				height: _cam_props_h,
			});
			
			_width = _size_camera.max.width;
			_height = _size_camera.max.height;
			_width_surface = _size_camera.min.width;
			_height_surface = _size_camera.min.height;
			_width_gui = _size_camera.max.width;
			_height_gui = _size_camera.max.height;
			
			var _is_active_fullscreen_extension = extension_exists("e_module_html_fullscreen");
			
			if (_is_active_fullscreen_extension) {
				html_fullscreen_custom(_width, _height);
			} else {
				window_set_size(_width, _height);
			}
			
			/// @set
			
			/* application surface */
			if (application_surface_is_enabled()) {
				surface_resize(application_surface, _width_surface, _height_surface);
			}
			
			/* display gui */
			display_set_gui_size(_width_gui, _height_gui);
			
			/* camera update */
			camera_base_w = _width;
			camera_base_h = _height;
		
			camera_set_view_size(camera, _width, _height);
		
			/* actions */
		
			self.bind_camera_for_view();
			self.emit_update_camera_size();
		
			return;
		}
		
		throw new Error("[o_game_service_camera]:@html5-v2 not choose env-type");
		
	}
	#endregion
	
});

/* init */

self.bind_camera_for_view();
