
/* state */

last_touch_id = undefined;
last_touch_tid = 0;
last_pos_xcf = 0;
last_pos_ycf = 0;
last_pos_win_x = 0;
last_pos_win_y = 0;
last_pos_gui_x = 0;
last_pos_gui_y = 0;
last_pos_world_x = 0;
last_pos_world_y = 0;
last_pos_world_flow = new StateMachineEvflow();

/* service providers */

GlobalService("control:mouse").provider("state", function() {

	return {
		id: last_touch_id,
		tid: last_touch_tid,
		xcf: last_pos_xcf,
		ycf: last_pos_ycf,
		win_x: last_pos_win_x,
		win_y: last_pos_win_y,
		gui_x: last_pos_gui_x,
		gui_y: last_pos_gui_y,
		world_x: last_pos_world_x,
		world_y: last_pos_world_y,
		flow: last_pos_world_flow.build_reader(),
 	};

});
