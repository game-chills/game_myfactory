
function extend_time_source_start(_parent, _period, _units, _callback, _args=undefined, _expiry_type=time_source_expire_after, _destroy=true) {
	
	var _closure = {};
	
	var _this = self;
	var _other = other;
	var _time_source = time_source_create(
		_parent,
		_period,
		_units,
		method(_closure, function(_this, _other, _args, _callback, _destroy) {
			if (_destroy) {
				time_source_destroy(self.time_source);
			}
			
			with (_other) {
				with (_this) {
					script_execute_ext(_callback, _args);
				}
			}
		}),
		[
			_this, _other, _args ?? [], _callback, _destroy
		],
		1,
		_expiry_type
	);
	
	_closure.time_source = _time_source;
	
	time_source_start(_time_source);
	
	return _time_source;
}

function extend_time_source_sync(_frames, _callback, _args) {
	
	return extend_time_source_start(
		time_source_game,
		_frames,
		time_source_units_frames,
		_callback,
		_args
	);
	
}
