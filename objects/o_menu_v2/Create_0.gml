event_inherited();


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
			subimg: _current_flag ? 0 : 1
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
	[{ cf: 0.5, px: +128 }],
	"menu.play.back"
)

ui_create_text(
	"play:reset",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: -128 }],
	"menu.play.reset:hint"
)

var _uia_menu_play_reset_yes = ui_create_button(
	"play:reset",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: 0 }],
	"menu.play.reset:yes",
	{
		text_base_color: merge_color(c_black, c_red, 0.6),
	}
)

var _uia_menu_play_reset_not = ui_create_button(
	"play:reset",
	[{ cf: 0.5 }],
	[{ cf: 0.5, px: +128 }],
	"menu.play.reset:not"
)

/* ui listeners */

ui_events.on(_uia_menu_play.ev_onclick, function() {
	
	ui_initiate_goto("play");
	
})

ui_events.on(_uia_menu_sound_switch.ev_onclick, function() {
	
	ui_events_actions.emit("settings:sound:switch");
	
})

ui_events.on(_uia_menu_play_back.ev_onclick, function() {
	
	ui_initiate_goto("main");
	
})

ui_events.on(_uia_menu_play_reset.ev_onclick, function() {
	
	ui_initiate_goto("play:reset");
	
})

ui_events.on(_uia_menu_play_reset_yes.ev_onclick, function() {
	
	ui_events_actions.emit("game:progress:reset");
	ui_initiate_goto("play");
	
})

ui_events.on(_uia_menu_play_reset_not.ev_onclick, function() {
	
	ui_initiate_goto("play");
	
})

ui_events.on(_uia_menu_play_start.ev_onclick, function() {
	
	ui_initiate_exit(function() {
		
		ui_events_actions.emit("game:start");
		
	})
	
})

/* ui listeners actions */

ui_events_actions.on("settings:sound:switch", function() {
	
	var _current_flag = GlobalService("settings:sound").request("get:active");
	GlobalService("settings:sound").request("set:active", !_current_flag);
	
});

ui_events_actions.on("game:progress:reset", function() {
	
	show_message("Нужно сбросить игру, когда будет реализован стор прогресса");
	
});

ui_events_actions.on("game:start", function() {
	
	if (MACRO_FLAG_IS_DEBUG) {
		show_message("[o_menu] start game");
	}
	
	room_goto_next();
	
});

/* state */

version_alpha = 0;

