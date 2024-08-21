
function emit_crash_unacceptable_behavior(_hint) {
	
	var _text = _hint ?? "unknown signature";
	show_error(_text, false);
	game_end(-1);
}

