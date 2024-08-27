
/* methods */

camera_room_center = function(_w, _h) {
	
	GlobalService("camera").request("set:pos_by_center", {
		x: room_width / 2,
		y: room_height / 2,
	});
	
}

/* listeners */

GlobalEventEmitter("camera").on("bind", function(_props) {
	
	camera_room_center(_props.base_w, _props.base_h);
	
});

GlobalEventEmitter("camera").on("resize", function(_props) {
	
	camera_room_center(_props.base_w, _props.base_h);
	
});
