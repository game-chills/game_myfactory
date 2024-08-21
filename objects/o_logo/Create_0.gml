
if (MACRO_FLAG_IS_DEBUG) {
	show_message("IS DEBUG MODE, PLEASE DISABLE BEFORE PRODUCTION PUSH")
}

time_max = game_get_speed(gamespeed_fps) * 2;
time_current = time_max;

logo_type = "text";
logo_meta = {
	text: "game-chills",
	subtext: "github.com/game-chills",
	text_font: font_logo,
	subtext_font: font_logo_small,
}

loading_parts = {
	e_yagames: false,
}
loading_parts_count_max = struct_names_count(loading_parts);
loading_parts_count = 0;

GlobalEventEmitter("loader").on("ready", function(_type) {
	if (!is_struct(loading_parts)) {
		return;
	}
	if (!is_string(_type)) {
		return;
	}
	if (!struct_exists(loading_parts, _type)) {
		emit_crash_unacceptable_behavior(
			"[o_logo] loader must correct unit-loaded"
		);
	}
	
	struct_remove(loading_parts, _type);
	
	++loading_parts_count;
	
	if (loading_parts_count == loading_parts_count_max) {
		loading_parts = undefined;	
	}
})