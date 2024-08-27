
/* state */

window_width = undefined;
window_height = undefined;
window_orientation = undefined;
window_orientation_flipped = undefined;
window_is_browser = undefined;

/* methods */

get_window_sizes = function() {
	var _width = window_get_width();
	var _height = window_get_height();
	var _orientation = display_get_orientation();
	var _is_browser = false;
	
	if (os_browser != browser_not_a_browser) {
		_width = browser_width;
		_height = browser_height;
		_is_browser = true;
	}
	
	var _orientation =
		_orientation == display_portrait || _orientation == display_portrait_flipped
		? "portrait"
		: "landscape"
	
	var _orientation_flipped =
		_orientation == display_portrait_flipped || _orientation == display_portrait_flipped
		? true
		: false
	
	return {
		is_browser: _is_browser,
		orientation: _orientation,
		orientation_flipped: _orientation_flipped,
		width: _width,
		height: _height,
	}
}

/* listeners */

GlobalService("window")
	.provider("w", function() {
		return window_width;
	})
	.provider("h", function() {
		return window_height;
	})
	.provider("all", function() {
		return {
			is_browser: window_is_browser,
			width: window_width,
			height: window_height,
			orientation: window_orientation,
			orientation_flipped: window_orientation_flipped
		}
	})
