
if (MACRO_FLAG_IS_DEBUG) {
	return;
}

if (os_browser == browser_not_a_browser) {
	emit_crash_unacceptable_behavior(
		"[o_validator_browser] game for only browser"
	);
}
