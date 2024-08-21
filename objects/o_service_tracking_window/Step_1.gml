
var _window_params = self.get_window_sizes();
var _has_change_props =
	window_width != _window_params.width ||
	window_height != _window_params.height ||
	window_orientation != _window_params.orientation ||
	window_orientation_flipped != _window_params.orientation_flipped;

if (_window_params.width == 0 || _window_params.height == 0) {
	return;
}
if (!_has_change_props) {
	return;
}

window_width = _window_params.width;
window_height = _window_params.height;
window_orientation = _window_params.orientation;
window_orientation_flipped = _window_params.orientation_flipped;
window_is_browser = _window_params.is_browser;

event_user(0);
