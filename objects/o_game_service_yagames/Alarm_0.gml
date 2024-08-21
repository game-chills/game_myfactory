
var _initStatus = YaGames_getInitStatus();
if (_initStatus > 0) {
	return try_game_ready_on();
}

alarm_set(0, game_get_speed(gamespeed_fps));
