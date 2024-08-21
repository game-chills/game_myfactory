
var _mouse = GlobalService("control:mouse").request("state");

if (_mouse.flow.is_outside()) {
	return;
}

draw_circle(
	_mouse.world_x,
	_mouse.world_y,
	32,
	false,
);
