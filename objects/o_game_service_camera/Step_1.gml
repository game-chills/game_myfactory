
if (tracking_room == room) {
	return;
}

tracking_room = room;

self.bind_camera_for_view();
