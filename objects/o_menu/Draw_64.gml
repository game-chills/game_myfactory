
draw_set_color(c_black);
draw_set_alpha(1);
draw_set_font(font_menu);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_text(_gui_w / 2, _gui_h / 2, "Play");


///// debug

//var _mouse = GlobalService("control:mouse").request("state");

//draw_text(256, 256, _mouse.flow.get_kind_name());
//draw_text(256, 280, _mouse.id);
//draw_text(256, 320, string("{0} {1}", _mouse.xcf, _mouse.ycf));
