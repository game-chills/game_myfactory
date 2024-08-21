
var _touches = GlobalService("control:touches").request("touches");
var _count = array_length(_touches);

if (_count == 0) {
	
	last_touch_id = undefined;
	
	self.read_touch_mouse(true);
	last_pos_world_flow.input(0);
	
	return;
}

if (is_undefined(last_touch_id)) {
	
	var _touch = _touches[0];
	
	last_touch_id = _touch.id;
	last_touch_tid = get_timer();
	last_pos_xcf = _touch.xcf;
	last_pos_ycf = _touch.ycf;
	last_pos_win_x = _touch.win_x;
	last_pos_win_y = _touch.win_y;
	last_pos_gui_x = _touch.gui_x;
	last_pos_gui_y = _touch.gui_y;
	last_pos_world_x = _touch.world_x;
	last_pos_world_y = _touch.world_y;
	
	last_pos_world_flow.reset();
	last_pos_world_flow.input(1);
	
	return;
	
}

var _touch_index = array_find_index(_touches, function(_touch) {
	
	return _touch.id == last_touch_id;
	
});

if (_touch_index != -1) {
	
	var _touch = _touches[_touch_index];
	
	last_touch_id = _touch.id;
	last_pos_xcf = _touch.xcf;
	last_pos_ycf = _touch.ycf;
	last_pos_win_x = _touch.win_x;
	last_pos_win_y = _touch.win_y;
	last_pos_gui_x = _touch.gui_x;
	last_pos_gui_y = _touch.gui_y;
	last_pos_world_x = _touch.world_x;
	last_pos_world_y = _touch.world_y;
	
	last_pos_world_flow.input(1);
	
	return;
	
} else {
	
	self.read_touch_mouse(false);
	last_pos_world_flow.input(0);
	
}
