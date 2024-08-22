
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(font_menu_ru);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _button_play_text = t("menu.play");

draw_sprite_stretched_ext(
	s_menu_button,
	0,
	_gui_w / 2 - string_width(_button_play_text) * 0.70,
	_gui_h / 2 - string_height(_button_play_text) * 0.70,
	string_width(_button_play_text) * 1.4,
	string_height(_button_play_text) * 1.4,
	c_black,
	0.5
);
draw_text(_gui_w / 2, _gui_h / 2, _button_play_text);

draw_text(_gui_w / 2, _gui_h / 2 + 128, t("menu.sound.switch"));

///// debug

//var _mouse = GlobalService("control:mouse").request("state");

//draw_text(256, 256, _mouse.flow.get_kind_name());
//draw_text(256, 280, _mouse.id);
//draw_text(256, 320, string("{0} {1}", _mouse.xcf, _mouse.ycf));
