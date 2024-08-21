
draw_clear_alpha(c_black, 1);

if (time_current < 1) {
	return
}

var _coef = time_current / time_max;
var _xcenter = display_get_gui_width() / 2;
var _ycenter = display_get_gui_height() / 2;
var _radius = 100;

if (logo_type == "text") {
	
	draw_set_alpha(_coef);
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_set_font(logo_meta.text_font);
	
	var _main_text_height = string_height(logo_meta.text);
	
	draw_text(_xcenter, _ycenter, logo_meta.text);
	draw_text(
		_xcenter, 
		_ycenter + _main_text_height + 32, 
		string(
			"{0}%",
			floor(loading_parts_count / loading_parts_count_max * 100)
		)
	);
	
	if (!is_string(logo_meta.subtext)) {
		return;
	}
	
	draw_set_color(c_dkgray);
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_right);
	draw_set_font(logo_meta.subtext_font);
	
	draw_text(_xcenter * 2 - 16, _ycenter * 2 - 16, logo_meta.subtext);
	
	return;
}


