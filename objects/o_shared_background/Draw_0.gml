
draw_clear(
	merge_color(back_color, $000000, 0.5)
);

draw_set_alpha(1);
draw_set_color(back_color);

var _cam_y = GlobalService("camera").request("get:y");
var _cam_h = GlobalService("camera").request("get:h");

draw_rectangle(
	0,
	_cam_y,
	room_width,
	_cam_y + _cam_h,
	false
);
