
/* state */
language = "en";
language_provided = false;

authorization_id = "unauthorized";
authorization_name = "unauthorized";
authorization_signature = "unauthorized";

/* methods */

init_prod = function() {
	
	flag_get_environment = false;
	flag_authorization = false;
	
	alarm_set(0, game_get_speed(gamespeed_fps));
	
}

init_mock = function() {

	extend_time_source_sync(
		5,
		function() {
			
			self.notify_extension_loaded();
			
		}
	);
	
}


try_game_ready_on = function() {
	
	game_ready_req_id = YaGames_GameReadyOn();

}

try_get_env = function() {
	
	player_init_req_id = YaGames_Player_Init(1, 1);
	get_environment_req_id = YaGames_getEnvironment();
	
}

try_authorization = function() {
	
	authorization_req_id = YaGames_OpenAuthDialog();
	
}

try_authorization_get_id = function() {
	
	try_authorization_get_id_req_id = YaGames_Player_GetUniqueID();
	
}

try_authorization_get_signature = function() {
	
	try_authorization_get_signature_req_id = YaGames_Player_GetSignature();
	
}

try_authorization_get_name = function() {
	
	try_authorization_get_name_req_id = YaGames_Player_GetName();
	
}

try_notify_extension_loaded = function() {
	if (!flag_get_environment) {
		return;
	}
	if (!flag_authorization) {
		return;
	}
	
	notify_extension_loaded();
}

notify_extension_loaded = function() {
	GlobalEventEmitter("loader").emit("ready", "e_yagames");
}

/* service providings */

GlobalService("yagames").provider("get:language", function() {
	return {
		language,
		provided: language_provided,
	};
});
GlobalService("yagames").provider("get:auth", function() {
	return {
		id: authorization_id,
		name: authorization_name,
		signature: authorization_signature
	};
});

/* init */

if (MACRO_FLAG_IS_DEBUG) {
	return init_mock();
}

if (!is_browser()) {
	return init_mock();
}

init_prod();
