
/* state */

env_is_browser = undefined;
env_is_desktop = undefined;

window_width = undefined;
window_height = undefined;
window_orientation = undefined;

display_width = undefined;
display_height = undefined;
display_orientation = undefined;
display_orientation_flipped = undefined;

/* methods */

get_window_params = function() {
	var _env_is_browser = false;
	var _env_is_desktop = false;
	
	var _window_width = window_get_width();
	var _window_height = window_get_height();
	var _window_orientation =
		_window_width > _window_height
		? "landscape"
		: "portrait"
	
	var _display_width = display_get_width();
	var _display_height = display_get_height();
	var _display_orientation_o = display_get_orientation();
	
	if (os_browser != browser_not_a_browser) {
		_env_is_browser = true;
		
		_window_width = browser_width;
		_window_height = browser_height;
	}
	
	if (os_type == os_windows ||
		os_type == os_linux ||
		os_type == os_macosx
	) {
		_env_is_desktop = true;
	}
	
	var _orientation =
		_display_orientation_o == display_portrait || 
		_display_orientation_o == display_portrait_flipped
		? "portrait"
		: "landscape"
	
	var _orientation_flipped =
		_display_orientation_o == display_portrait_flipped || 
		_display_orientation_o == display_landscape_flipped
		? true
		: false
	
	return {
		env_is_browser: _env_is_browser,
		env_is_desktop: _env_is_desktop,
		
		window_width: _window_width,
		window_height: _window_height,
		window_orientation: _window_orientation,
		
		display_width: _display_width,
		display_height: _display_height,
		display_orientation: _orientation,
		display_orientation_flipped: _orientation_flipped,
	}
}
