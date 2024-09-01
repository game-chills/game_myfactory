/* EVENT:LIST */
/*
	pause.status (bool)
*/

/* state */

pause = true;

pause_instance_listeners = [];

/* methods */

emit_notify_pause = function() {
	
	GlobalEventEmitter("pause").emit("status", pause);
	
}

add_transition_instance = function(_instance, _to_pause, _to_unpause) {
	
	array_push(pause_instance_listeners, {
		instance: _instance,
		to_pause: _to_pause,
		to_unpause: _to_unpause,
		last_pause: undefined,
	});
	
}

add_transition_instance_provide_variable = function(_instance, _variable) {
	
	var _closure = {
		variable: _variable,	
	}
	
	var _provide_true = method(_closure, function(_instance) {
		variable_instance_set(_instance, self.variable, true)
	});
	
	var _provide_false = method(_closure, function(_instance) {
		variable_instance_set(_instance, self.variable, false)
	});
	
	self.add_transition_instance(_instance, _provide_true, _provide_false);
	
}

emit_transition_instance = function() {

	var _emit_key =
		pause
		? "to_pause"
		: "to_unpause"
	
	var _filtered_listeners = [];
	var _size = array_length(pause_instance_listeners);
	var _listener;
	
	for (var i = 0; i < _size; ++i) {
		
		_listener = pause_instance_listeners[i];
		
		if (!instance_exists(_listener.instance)) {
			continue;
		}
		
		array_push(_filtered_listeners, _listener);
		
		if (_listener.last_pause == pause) {
			continue;
		}
		
		_listener.last_pause = pause;
		_listener[$ _emit_key](_listener.instance);
		
	}
	
	pause_instance_listeners = _filtered_listeners;
	
}

/* service providers */

GlobalService("pause").provider("enable", function() {
	
	pause = true;
	self.emit_notify_pause();
	self.emit_transition_instance();
	
});

GlobalService("pause").provider("disable", function() {
	
	pause = false;
	self.emit_notify_pause();
	self.emit_transition_instance();
	
});

GlobalService("pause").provider("status", function() {
	
	self.emit_notify_pause();
	self.emit_transition_instance();
	
});

GlobalService("pause").provider("on:transition:instance", function(_props) {
	
	var _instance = _props.instance;
	var _to_pause = _props.to_pause;
	var _to_unpause = _props.to_unpause;
	
	self.add_transition_instance(_instance, _to_pause, _to_unpause);
	self.emit_transition_instance();
	
})

GlobalService("pause").provider("on:transition:instance:variable", function(_props) {
	
	var _instance = _props.instance;
	var _variable = _props.variable;
	
	self.add_transition_instance_provide_variable(_instance, _variable);
	self.emit_transition_instance();
	
})
