
if (MACRO_FLAG_IS_DEBUG) {
	return;
}

if (!is_browser()) {
	emit_crash_unacceptable_behavior(
		"[o_validator_browser] game for only browser"
	);
}

instance_destroy();
