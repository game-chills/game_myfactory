
/* ui engine */

ui_constants = {
	transition_stage_in_time: game_get_speed(gamespeed_fps) * 0.7,
	transition_stage_out_time: game_get_speed(gamespeed_fps) * 0.7,
}

ui = {
	active: true,
	visible: true,
	layer: "main",
	transition: {
		next_layer: "main",
		stage: "in",
		time_max: ui_constants.transition_stage_in_time,
		time_current: 0,
	},
	draw: {
		alpha: 0,	
	},
	elements: {},
}

ui_control = {
	mouse_last_component: undefined,
}

ui_create_button = function(
	_layer,
	_x,
	_y,
	_key,
	_action=undefined
) {
	var _type = "button";
	
	_action ??= string("{0}/{1}", _type, _key);
	
	var _component = {
		type: _type,
		x: _x,
		y: _y,
		key: _key,
		action: _action,
		state: {
			xc: 0,
			yc: 0,
			x1: 0,
			y1: 0,
			x2: 0,
			y2: 0,
			width: 0,
			height: 0,
			
			text: _key,
			font: 0,
			
			type: "none", // none / hover / pressed / released
		},
	}
	
	var _layer_elements = ui.elements[$ _layer] ?? [];
	ui.elements[$ _layer] = _layer_elements;
	
	array_push(_layer_elements, _component);
	
	return {
		ev_onclick: "mouse:click::" + _action,
	}
}

ui_create_button_icon = function(
	_layer,
	_x,
	_y,
	_key,
	_icon_provider,
	_action=undefined
) {
	var _type = "button-icon";
	
	_action ??= string("{0}/{1}", _type, _key);
 	
	var _component = {
		type: _type,
		x: _x,
		y: _y,
		key: _key,
		action: _action,
		icon_provider: _icon_provider,
		state: {
			xc: 0,
			yc: 0,
			x1: 0,
			y1: 0,
			x2: 0,
			y2: 0,
			width: 0,
			height: 0,
			
			text: _key,
			font: 0,
			
			type: "none", // none / hover / pressed / released
			
			tx: 0,
			ty: 0,
			isprite: undefined,
			isubimg: 0,
			ix1: 0,
			iy1: 0,
			ix2: 0,
			iy2: 0,
		},
	}
	
	var _layer_elements = ui.elements[$ _layer] ?? [];
	ui.elements[$ _layer] = _layer_elements;
	
	array_push(_layer_elements, _component);
	
	return {
		ev_onclick: "mouse:click::" + _action,
	}
}

ui_methods_calculate_pos = function(_pos_components, _methods) {
	var _length = array_length(_pos_components);
	var _display_get_gui_main_axios_size = _methods.display_get_gui_main_axios_size;
	
	var _pos = 0;
	
	var _struct;
	for (var i = 0; i < _length; ++i) {
		_struct = _pos_components[i];
		
		if (struct_exists(_struct, "cf")) {
			_pos += _struct.cf * _display_get_gui_main_axios_size();	
		}
		if (struct_exists(_struct, "px")) {
			_pos += _struct.px;	
		}
	}
	
	return _pos;
}

ui_methods_calculate_pos_x = function(_pos_components) {
	static _methods = {
		display_get_gui_main_axios_size: display_get_gui_width
	}
	
	return ui_methods_calculate_pos(_pos_components, _methods);
}

ui_methods_calculate_pos_y = function(_pos_components) {
	static _methods = {
		display_get_gui_main_axios_size: display_get_gui_height
	}
	
	return ui_methods_calculate_pos(_pos_components, _methods);
}

ui_events = new EventEmitter();

version_alpha = 0;

/* ui description */

var _uia_menu_play = ui_create_button(
	"main",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: -64 }],
	"menu.play",
)

var _uia_menu_sound_switch = ui_create_button_icon(
	"main",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: +64 }],
	"menu.audio.switch",
	function() {
		
		var _current_flag = GlobalService("settings:sound").request("get:active");
		return {
			sprite: s_icon_sound,
			subimg: _current_flag ? 0 : 1,
		}
	}
)

/* ui listeners */

ui_events.on(_uia_menu_play.ev_onclick, function() {
	show_message("PLAY");
})

ui_events.on(_uia_menu_sound_switch.ev_onclick, function() {
	
	var _current_flag = GlobalService("settings:sound").request("get:active");
	GlobalService("settings:sound").request("set:active", !_current_flag);
	
})
