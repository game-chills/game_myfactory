
/* ui engine */

/// @constants

ui_constants = {
	transition_stage_in_time: game_get_speed(gamespeed_fps) * 0.2,
	transition_stage_out_time: game_get_speed(gamespeed_fps) * 0.2,
}

/// @state

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

/// @components

ui_create_button = function(
	_layer,
	_x,
	_y,
	_key,
	_params=undefined,
) {
	var _type = "button";
	
	var _jparams = _params ?? {};
	
	var _action = string("{0}/{1}", _type, _key);
	
	var _component = {
		type: _type,
		x: _x,
		y: _y,
		key: _key,
		action: _action,
		params: {
			text_base_color: _jparams[$ "text_base_color"] ?? c_black,	
		},
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
	_params=undefined,
) {
	var _type = "button-icon";
	
	var _jparams = _params ?? {};
	
	var _action = string("{0}/{1}", _type, _key);
 	
	var _component = {
		type: _type,
		x: _x,
		y: _y,
		key: _key,
		action: _action,
		icon_provider: _icon_provider,
		params: {
			text_base_color: _jparams[$ "text_base_color"] ?? c_black,	
		},
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

ui_create_text = function(
	_layer,
	_x,
	_y,
	_key,
	_halign=fa_center,
	_valign=fa_center
) {
	var _type = "text";
	
	var _component = {
		type: _type,
		x: _x,
		y: _y,
		key: _key,
		halign: _halign,
		valign: _valign,
		state: {
			xc: 0,
			yc: 0,
			
			text: _key,
			font: 0,
		},
	}
	
	var _layer_elements = ui.elements[$ _layer] ?? [];
	ui.elements[$ _layer] = _layer_elements;
	
	array_push(_layer_elements, _component);
	
}

/// @calculators

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

/// @methods

ui_void = function() {
	
	ui.layer = "void";
	
	ui.transition.next_layer = undefined;
	ui.transition.stage = "interaction";
	ui.transition.time_max = 0;
	ui.transition.time_current = 0;
	
}


/// @triggers

ui_initiate_goto = function(_layer) {
	
	if (ui.transition.stage != "interaction") {
		throw new Error("[o_menu]:ui_initiate_goto bad current stage");
	}
	
	ui.transition.next_layer = _layer;
	ui.transition.stage = "out";
	ui.transition.time_max = ui_constants.transition_stage_out_time;
	ui.transition.time_current = 0;
	
}

ui_initiate_exit = function(_callback) {
	
	ui_events.on("goto:void:exit", _callback);
	ui_initiate_goto("void");
	
}

/// @events

ui_events = new EventEmitter();

/* ui description */

var _uia_menu_play = ui_create_button(
	"main",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: -64 }],
	"menu.play.title",
	{
		text_base_color: merge_color(c_black, #8BC34A, 0.7),
	}
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

var _uia_menu_play_start = ui_create_button(
	"play",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: -128 }],
	"menu.play.start",
	{
		text_base_color: merge_color(c_black, #8BC34A, 0.7),
	}
)

var _uia_menu_play_reset = ui_create_button(
	"play",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: 0 }],
	"menu.play.reset",
	{
		text_base_color: merge_color(c_black, c_red, 0.6),
	}
)

var _uia_menu_play_back = ui_create_button(
	"play",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: 128 }],
	"menu.play.back",
)

ui_create_text(
	"play:reset",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: -64 }],
	"menu.play.reset:hint",
)

var _uia_menu_play_reset_yes = ui_create_button(
	"play:reset",
	[{ cf: 0.5, px: -330 }],
	[{ cf: 0.5, px: +64 }],
	"menu.play.reset:yes",
	{
		text_base_color: merge_color(c_black, c_red, 0.6),
	}
)

var _uia_menu_play_reset_not = ui_create_button(
	"play:reset",
	[{ cf: 0.5, px: 330 }],
	[{ cf: 0.5, px: +64 }],
	"menu.play.reset:not",
)

/* ui listeners */

ui_events.on(_uia_menu_play.ev_onclick, function() {
	
	ui_initiate_goto("play");
	
})

ui_events.on(_uia_menu_sound_switch.ev_onclick, function() {
	
	var _current_flag = GlobalService("settings:sound").request("get:active");
	GlobalService("settings:sound").request("set:active", !_current_flag);
	
})

ui_events.on(_uia_menu_play_back.ev_onclick, function() {
	
	ui_initiate_goto("main");
	
})

ui_events.on(_uia_menu_play_reset.ev_onclick, function() {
	
	ui_initiate_goto("play:reset");
	
})

ui_events.on(_uia_menu_play_reset_yes.ev_onclick, function() {
	
	show_message("Нужно сбросить игру, когда будет реализован стор прогресса");
	
	ui_initiate_goto("play");
	
})

ui_events.on(_uia_menu_play_reset_not.ev_onclick, function() {
	
	ui_initiate_goto("play");
	
})

ui_events.on(_uia_menu_play_start.ev_onclick, function() {
	
	ui_initiate_exit(function() {
		
		show_message("Start");
		
	})
	
})

/* ui listeners system */

ui_events.on("goto:to-in", function(_props) {
	
	var _layer = _props.layer;
	if (_layer != "void") {
		return;
	}
	
	ui_events.emit("goto:void:exit");
	ui_events.off("goto:void:exit");
	ui_void();
	
});

/* state */

version_alpha = 0;

