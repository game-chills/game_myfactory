
function is_mobile() {
	return 
		os_type == os_android ||
		os_type == os_ios
}

function is_browser() {
	return os_browser != browser_not_a_browser;	
}

function is_desktop() {
	return 
		os_type == os_windows ||
		os_type == os_linux ||
		os_type == os_macosx
}

function is_desktop_native() {
	return is_desktop() && !is_browser();
}

function is_desktop_browser() {
	return is_desktop() && is_browser();	
}

function is_mobile_native() {
	return is_mobile() && !is_browser();	
}

function is_mobile_browser() {
	return is_mobile() && is_browser();	
}
