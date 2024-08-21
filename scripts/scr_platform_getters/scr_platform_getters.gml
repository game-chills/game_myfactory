
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
