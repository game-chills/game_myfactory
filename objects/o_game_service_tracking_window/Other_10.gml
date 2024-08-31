
if (MACRO_FLAG_IS_DEBUG) {
	show_debug_message({
		type: "Change window props",
		timer: get_timer(),
		env_is_browser,
		env_is_desktop,
		window_width,
		window_height,
		window_orientation,
		display_width,
		display_height,
		display_orientation,
		display_orientation_flipped,
	});
}

GlobalEventEmitter("window").emit("change", {
	env_is_browser,
	env_is_desktop,
	window_width,
	window_height,
	window_orientation,
	display_width,
	display_height,
	display_orientation,
	display_orientation_flipped,
});

