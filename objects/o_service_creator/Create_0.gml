
// level:0
instance_create_depth(0, 0, 0, o_game_service_tracking_window);

// level:1
instance_create_depth(0, 0, 0, o_game_service_validator_browser);
instance_create_depth(0, 0, 0, o_game_service_camera);
instance_create_depth(0, 0, 0, o_game_service_control_touches);
instance_create_depth(0, 0, 0, o_game_service_control_mouse);
instance_create_depth(0, 0, 0, o_game_service_yagames);
instance_create_depth(0, 0, 0, o_game_service_language);
instance_create_depth(0, 0, 0, o_game_service_settings);

// level:2
instance_create_depth(0, 0, 0, o_game_service_camera_center);

// clear
instance_destroy();
