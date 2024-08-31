
var _window_params = self.get_window_params();
var _has_change_props =
	window_width != _window_params.window_width ||
	window_height != _window_params.window_height ||
	display_orientation != _window_params.display_orientation ||
	display_orientation_flipped != _window_params.display_orientation_flipped;

if (_window_params.window_width == 0 || _window_params.window_height == 0) {
	return;
}
if (!_has_change_props) {
	return;
}

env_is_browser = _window_params.env_is_browser;
env_is_desktop = _window_params.env_is_desktop;

window_width = _window_params.window_width;
window_height = _window_params.window_height;
window_orientation = _window_params.window_orientation;

display_width = _window_params.display_width;
display_height = _window_params.display_height;
display_orientation = _window_params.display_orientation;
display_orientation_flipped = _window_params.display_orientation_flipped;

event_user(0);
