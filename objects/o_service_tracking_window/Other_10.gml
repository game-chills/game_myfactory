
if (MACRO_FLAG_IS_DEBUG) {
	show_debug_message({
		type: "Change window props",
		is_browser: window_is_browser,
		width: window_width,
		height: window_height,
		orientation: window_orientation,
		orientation_flipped: window_orientation_flipped,
	});
}

GlobalEventEmitter("window").emit("change", {
	is_browser: window_is_browser,
	width: window_width,
	height: window_height,
	orientation: window_orientation,
	orientation_flipped: window_orientation_flipped,
});

