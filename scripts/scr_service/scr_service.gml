
/* You need control memory leak */
/* pattern for immortal objects */

function Service() constructor {
	
	#region __constructor
	{
		self.__events = {};	
	}
	#endregion
	
	function provider(_event_name, _callback) {
		
		if (variable_struct_exists(self.__events, _event_name)) {
			throw new Error("[scr_service] emit-provider already set");	
		}
		
		struct_set(self.__events, _event_name, _callback);
		
		return self;
		
	}
	
	function request(_event_name, _argument) {
		
		if (!variable_struct_exists(self.__events, _event_name)) {
			throw new Error("[scr_service] provider not found");
		}
		
		var _reader = variable_struct_get(self.__events, _event_name);
		return _reader(_argument);
		
	}
	
}

function __GlobalServiceMap() {
	
	static _gmap = {};
	return _gmap;
	
}

function GlobalService(_name) {
	
	static _gmap = __GlobalServiceMap();
	
	var _emitter = struct_get(_gmap, _name);
	if (is_struct(_emitter)) {
		return _emitter;
	}
	
	var _emitter = new Service();
	struct_set(_gmap, _name, _emitter);
	
	return _emitter;
	
}
