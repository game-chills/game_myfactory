
/* state */

touches_count = 0;
touches_list = [];

touch_mouse = undefined;

touch_mouse_mode_x = 0;
touch_mouse_mode_y = 0;

/* methods */

project_camera_to_world = function() {
	var _touch;
	var _world_pos;
	for (var i = 0; i < touches_count; ++i) {
		_touch = touches_list[i];
		_world_pos = GlobalService("camera").request("get:world_pos", {
			xcf: _touch.xcf,
			ycf: _touch.ycf,
		});
		
		_touch.world_x = _world_pos.x_world;
		_touch.world_y = _world_pos.y_world;
	}
}

update_touches = function() {
	
	touch_mouse = undefined;
	
	if (is_desktop() && html_fullscreen_extension_available()) {
		var _is_mouse_click = mouse_check_button(mb_left);
	
		var _mxcf = window_mouse_get_x() / browser_width;
		var _mycf = window_mouse_get_y() / browser_height;
	
		var _touch = {
			id: -11,
	        xcf: _mxcf,
	        ycf: _mycf,
	        xradius: 1,
	        yradius: 1,
	        angle: point_direction(
				touch_mouse_mode_x,
				touch_mouse_mode_y,
				_mxcf,
				_mycf,
			),
	        force: 1,
	        win_x: _mxcf * window_get_width(),
	        win_y: _mycf * window_get_height(),
	        gui_x: _mxcf * display_get_gui_width(),
	        gui_y: _mycf * display_get_gui_height(),
		}
	
		touch_mouse_mode_x = _mxcf;
		touch_mouse_mode_y = _mycf;
	
		touches_count = 1;
		touches_list = [_touch];
	
		self.project_camera_to_world();
		
		touch_mouse = _touch;
		
		if (!_is_mouse_click) {
			touches_count = 0;
			touches_list = [];
		
			return;
		}
		
		return;
	
	}

	if (is_desktop()) {
		var _is_mouse_click = mouse_check_button(mb_left);
	
		var _mxcf = window_mouse_get_x() / window_get_width();
		var _mycf = window_mouse_get_y() / window_get_height();
	
		var _touch = {
			id: -11,
	        xcf: _mxcf,
	        ycf: _mycf,
	        xradius: 1,
	        yradius: 1,
	        angle: point_direction(
				touch_mouse_mode_x,
				touch_mouse_mode_y,
				_mxcf,
				_mycf,
			),
	        force: 1,
	        win_x: _mxcf * window_get_width(),
	        win_y: _mycf * window_get_height(),
	        gui_x: _mxcf * display_get_gui_width(),
	        gui_y: _mycf * display_get_gui_height(),
		}
	
		touch_mouse_mode_x = _mxcf;
		touch_mouse_mode_y = _mycf;
	
		touches_count = 1;
		touches_list = [_touch];
		
		self.project_camera_to_world();
	
		touch_mouse = _touch;
		
		if (!_is_mouse_click) {
			touches_count = 0;
			touches_list = [];
		
			return;
		}
		
		return;
	
	}
	
	if (is_browser() && is_mobile() && html_fullscreen_extension_available()) {
	
		var _touches = html_fullscreen_touches();
		var _count = array_length(_touches);
	
		touches_count = _count;
		touches_list = _touches;
	
		self.project_camera_to_world();
		return;
	
	} 
	
}

/* service providers */

GlobalService("control:touches").provider("mouse", function() {
	return touch_mouse;
});

GlobalService("control:touches").provider("count", function() {
	return touches_count;
});
GlobalService("control:touches").provider("touch", function(_index) {
	return touches_list[_index];
});
GlobalService("control:touches").provider("touches", function() {
	return touches_list;
});
