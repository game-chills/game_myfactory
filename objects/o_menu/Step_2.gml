
if (!ui.active) {
	return;
}

/* transitions */

if (ui.transition.stage == "interaction" && is_string(ui.transition.next_layer)) {
	if (ui.transition.next_layer == ui.layer) {
		ui.transition.next_layer = undefined;
	} else {
		ui.transition.stage = "out";
		ui.transition.time_max = ui_constants.transition_stage_out_time;
	}
}

if (ui.transition.stage != "interaction") {
	ui.transition.time_current += 1;
	
	if (ui.transition.time_current >= ui.transition.time_max) {
		if (ui.transition.stage == "out") {
			ui.transition.stage = "in";
			ui.transition.time_current = 0;
			ui.transition.time_max = ui_constants.transition_stage_in_time;
			
			ui.layer = ui.transition.next_layer;
			ui.transition.next_layer = undefined;
		}
		if (ui.transition.stage == "in") {
			ui.transition.stage = "interaction";
			ui.transition.time_current = 0;
			ui.transition.time_max = 0;
		}
	}
}

if (ui.transition.stage == "interaction") {
	ui.draw.alpha = 1;
}
if (ui.transition.stage == "in") {
	ui.draw.alpha = 
		ui.transition.time_current / ui.transition.time_max;
}
if (ui.transition.stage == "out") {
	ui.draw.alpha = 
		1 - ui.transition.time_current / ui.transition.time_max;
}

/* update flags */

var _is_need_update_texts = true;
var _is_need_update_sizes = true;
var _is_need_update_position = true;
var _is_need_interaction_reset = ui.transition.stage != "out";
var _is_need_interaction_update = ui.transition.stage == "interaction";

/* s:calc components calculate texts */

if (_is_need_update_texts) {
	
	var _layer = ui.layer;
	var _components = ui.elements[$ _layer];
	
	if (is_array(_components)) {
		var _length = array_length(_components);
		var _component;
		for (var i = 0; i < _length; ++i) {
			_component = _components[i];
			
			if (_component.type == "button") {
				_component.state.text = t(_component.key);
				_component.state.font = font_menu_ru;
				
				continue;
			}
		}
	}

}

/* s:calc components calculate sizes */

if (_is_need_update_sizes) {
	
	var _layer = ui.layer;
	var _components = ui.elements[$ _layer];
	
	if (is_array(_components)) {
		var _length = array_length(_components);
		var _component;
		var _width;
		var _height;
		for (var i = 0; i < _length; ++i) {
			_component = _components[i];
			
			if (_component.type == "button") {
				_width = 600;
				_height = 100;
			}
			
			_component.state.width = _width;
			_component.state.height = _height;
			
			continue;
		}
	}
	
}

/* s:calc components calculate positions */

if (_is_need_update_position) {

	var _layer = ui.layer;
	var _components = ui.elements[$ _layer];
	
	if (is_array(_components)) {
		var _length = array_length(_components);
		var _component;
		var _xc;
		var _yc;
		var _x1;
		var _y1;
		var _x2;
		var _y2;
		for (var i = 0; i < _length; ++i) {
			_component = _components[i];
			
			if (_component.type == "button") {
				_xc = ui_methods_calculate_pos_x(
					_component.x
				);
				_yc = ui_methods_calculate_pos_y(
					_component.y
				);
				_x1 = _xc - _component.state.width / 2;
				_y1 = _yc - _component.state.height / 2;
				_x2 = _xc + _component.state.width / 2;
				_y2 = _yc + _component.state.height / 2;
				
				_component.state.xc = _xc;
				_component.state.yc = _yc;
				_component.state.x1 = _x1;
				_component.state.y1 = _y1;
				_component.state.x2 = _x2;
				_component.state.y2 = _y2;
				
				continue;
			}
		}
	}
	
}

/* s:intr components interactive reset */

var _control_mouse = GlobalService("control:mouse").request("state");

if (ui.transition.stage != "interaction") {
	ui_control.mouse_last_component = undefined;
}
show_debug_message(_control_mouse.flow.get_kind_name());
if (is_struct(ui_control.mouse_last_component)) {
	if (_control_mouse.flow.is_outside()) {
		ui_control.mouse_last_component = undefined;
	}
}

if (_is_need_interaction_reset) {
 	
	var _layer = ui.layer;
	var _components = ui.elements[$ _layer];
	
	if (is_array(_components)) {
		var i;
		var _length = array_length(_components);
		var _component;
		
		for (i = 0; i < _length; ++i) {
			_component = _components[i];
			
			if (_component.type == "button") {
				_component.state.type = "none";
				
				continue;
			}
		}
		
	}
	
}

/* s:intr components interactive update */

if (_is_need_interaction_update) {
	
	var _layer = ui.layer;
	var _components = ui.elements[$ _layer];
	
	if (is_array(_components)) {
		var i;
		var _length = array_length(_components);
		var _component;
		var _is_same_last_component;
		
		var _has_collision;
		
		/* cycle mouse handling */
		for (i = 0; i < _length; ++i) {
			_component = _components[i];
			
			if (_component.type == "button") {
				_has_collision = point_in_rectangle(
					_control_mouse.gui_x,
					_control_mouse.gui_y,
					_component.state.x1,
					_component.state.y1,
					_component.state.x2,
					_component.state.y2
				)
				
				if (_has_collision) {
					
					if (is_desktop()) {
						_component.state.type = "hover";	
					}
					if (is_mobile() && _control_mouse.flow.is_active()) {
						_component.state.type = "hover";
					}
					
					if (is_undefined(ui_control.mouse_last_component)) {
						if (_control_mouse.flow.is_in()) {
							ui_control.mouse_last_component = _component;
						}
					}
					
					var _is_same_last_component =
						ui_control.mouse_last_component == _component;
					
					if (_is_same_last_component) {
						if (_control_mouse.flow.is_active()) {
							_component.state.type = "pressed";
						}
					
						if (_control_mouse.flow.is_out()) {
							_component.state.type = "released";
						}
					}
				}
				
				if (_component.state.type == "released") {
					self.ui_events.emit("mouse:click::" + _component.action);
				}
				
				if (_has_collision) {
					break;
				}
			}

		}
	
		
	}
	
}
