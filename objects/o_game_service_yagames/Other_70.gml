
if (async_load[? "type"] != YaGames_AsyncEvent) {
	return;
}

if ((async_load[? "request_id"] == game_ready_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallGameReady:
		{
			try_get_env();
		}
		break;
		
		default:
		{
			var _msg = "";
			
			if (is_string(async_load[? "name"])) {
				_msg += async_load[? "name"] + "; ";
			}
			if (is_string(async_load[? "message"])) {
				_msg += async_load[? "message"] + "; ";
			}
			
			emit_crash_unacceptable_behavior(
				"[o_game_service_yagames] yagames game-ready is error - {0}",
				_msg
			);
		}
	}
}

if ((async_load[? "request_id"] == player_init_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallPlayerInit:
		{
			try_authorization();
		}
		break;
		
		default:
		{
			flag_authorization = true;
			try_notify_extension_loaded();
		}
	}
}

if ((async_load[? "request_id"] == authorization_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallPlayerLogged:
		case YaGames_CallPlayerAlreadyLogged:
		{
			try_authorization_get_id();
		}
		break;
		
		default:
		{
			flag_authorization = true;
			try_notify_extension_loaded();
		}
	}
}

if ((async_load[? "request_id"] == try_authorization_get_id_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallPlayerIdRequest:
		{
			authorization_id = async_load[? "value"];
			
			try_authorization_get_signature();
		}
		break;
		
		default:
		{
			flag_authorization = true;
			try_notify_extension_loaded();
		}
	}
}

if ((async_load[? "request_id"] == try_authorization_get_signature_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallPlayerSignatureRequest:
		{
			
			authorization_signature = async_load[? "value"];
			
			try_authorization_get_name();
		}
		break;
		
		default:
		{
			flag_authorization = true;
			try_notify_extension_loaded();
		}
	}
}

if ((async_load[? "request_id"] == try_authorization_get_name_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallPlayerNameRequest:
		{
			
			authorization_name = async_load[? "value"];
			
			{
				flag_authorization = true;
				try_notify_extension_loaded();
			}
		}
		break;
		
		default:
		{
			flag_authorization = true;
			try_notify_extension_loaded();
		}
	}
}


if ((async_load[? "request_id"] == get_environment_req_id)) {
	
	switch (async_load[? "event"]) {	
		
		case YaGames_CallEnvironment:
		{
			var _data = json_parse(async_load[? "data"]);
			var _lang = _data.i18n.lang;
			
			language = _lang;
			language_provided = true;
			
			flag_get_environment = true;
			try_notify_extension_loaded();
		}
		break;
		
		default:
		{
			emit_crash_unacceptable_behavior(
				"[o_game_service_yagames] fail get environment"
			)
		}
	}
}