event_inherited();

/* draw version */

draw_set_font(font_logo_small);
draw_set_color(c_black);
draw_set_alpha(version_alpha);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);

draw_text(
	display_get_gui_width() - 4,
	display_get_gui_height() - 4,
	string("v.{0}", MACRO_CONST_VERSION)
);
