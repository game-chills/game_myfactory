
function __t_memory() {
	
	static _memory = {
		available_languages: undefined,
		default_language: undefined,
		current_language: undefined,
		translate: {},
	}
	return _memory;
	
}

function __t_validate_lancode(_lancode) {
	if (!is_string(_lancode)) {
		throw ({
			message: "[scr_translate]:0x00 lancode must be string"
		})
	}
	
	if (string_lower(_lancode) != _lancode) {
		throw ({
			message: "[scr_translate]:0x01 lancode must be lowercase string"
		})
	}
		
	if (string_length(_lancode) != 2) {
		throw ({
			message: "[scr_translate]:0x02 lancode must be 2 symbol length"
		})
	}
}

function t_static_set_available_languages(_available_languages) {
	
	var _memory = __t_memory();
	
	if (is_array(_memory.available_languages)) {
		throw ({
			message: "[scr_translate]:0x10 available_languages is already sets"
		})
	}
	
	var _count = array_length(_available_languages);
	if (_count == 0) {
		throw ({
			message: "[scr_translate]:0x11 available_languages is empty"
		})
	}
	
	var _lancode;
	for (var i = 0; i < _count; ++i) {
		_lancode = _available_languages[i];
		__t_validate_lancode(_lancode);
	}
	
	_memory.available_languages = array_unique(_available_languages);
	
}

function t_static_set_default_language(_default_language) {
	
	var _memory = __t_memory();
	
	__t_validate_lancode(_default_language);
	
	if (!is_array(_memory.available_languages)) {
		throw ({
			message: "[scr_translate]:0x21 available_languages is not ready"
		})
	}
	
	if (is_string(_memory.default_language)) {
		throw ({
			message: "[scr_translate]:0x21 default_language is already sets"
		})
	}
	
	var _closure = { lancode: _default_language };
	var _index = array_find_index(_memory.available_languages, method(_closure, function(_value) {
		return _value == self.lancode;
	}));
	
	if (_index == -1) {
		throw ({
			message: "[scr_translate]:0x22 language is not available"
		})
	}
	
	_memory.default_language = _default_language;
	
}

function t_static_validate_ready() {
	
	var _memory = __t_memory();
	
	if (!is_array(_memory.available_languages)) {
		throw ({
			message: "[scr_translate]:0x40 available_languages is not ready"
		})
	}
	
	if (!is_string(_memory.default_language)) {
		throw ({
			message: "[scr_translate]:0x41 default_language is not ready"
		})
	}
	
}

function t_append_content(_language, _json_translate, _prefix="") {
	
	static _memory = (function() {
		t_static_validate_ready();
		return __t_memory();
	})();
	
	if (!is_struct(_json_translate)) {
		throw ({
			message: "[scr_translate]:0x50 json_translate is not struct"
		});
	}
	
	if (string_pos(".", _prefix) != 0) {
		throw ({
			message: "[scr_translate]:0x52 json-key-prefix must dont include symbol ."
		});
	}
	
	var _closure = {
		language: _language,
		json: _json_translate,
		memory: _memory,
	}
	
	with (_closure) {
	
		var _available_lancode_index = array_find_index(
			_memory.available_languages, 
			function(_value) {
				return _value == self.language;
			}
		);
	
		if (_available_lancode_index == -1) {
			return false;
		}
	
		var _translate = self.memory.translate;
		var _translate_lan = struct_get(_translate, self.language) ?? {};
			
		struct_set(_translate, self.language, _translate_lan);
			
		var _stack = [{
			root: self.json,
			path: _prefix,
		}]
		
		var _comp;
		var _path;
		var _node;
		var _node_keys;
		var _node_length;
		var _node_key;
		var _node_value;
		var _finally_key;
		var i;
		while (array_length(_stack) > 0) {
				
			_comp = array_pop(_stack);
			_path = _comp.path;
			_node = _comp.root;
			_node_keys = struct_get_names(_node);
			_node_length = array_length(_node_keys);
				
			for (i = 0; i < _node_length; ++i) {
				
				_node_key = _node_keys[i];
				_node_value = _node[$ _node_key];
					
				if (string_pos(".", _node_key) != 0) {
					throw ({
						message: "[scr_translate]:0x51 json-key must dont include symbol ."
					});
				}
				
				_finally_key = 
					_path == "" 
					? _node_key
				    : _path + "." + _node_key;
				
				if (is_struct(_node_value)) {
					array_push(_stack, {
						root: _node_value,
						path: _finally_key,
					});
					continue;	
				}
					
				_translate_lan[$ _finally_key] = 
					is_array(_node_value)
					? _node_value
					: string(_node_value);
					
			}
				
		}
		
	}
	
	return true;
	
}

function t_append_content__sync_include_file(_file_name, _prefix="") {
	
	var _handler = undefined;
	
	var _closure = {
		prefix: _prefix,
	}
		
	try {
		
		_handler = file_text_open_read(_file_name);
		
		var _file_content = "";
        while (!file_text_eof(_handler)) 
        {
            _file_content += file_text_readln(_handler) + "\n";
        }
		
		var _json = json_parse(_file_content);
		
		with (_closure) {
			
			struct_foreach(_json, function(_language, _json_translate) {
				t_append_content(_language, _json_translate, self.prefix);
			});
		
		}
		
	} finally {
		if (!is_undefined(_handler)) {
			file_text_close(_handler);
		}
	}
	
}

function t_append_content__sync_include_files(_prefix, _files) {
	
	_prefix = _prefix + ".";
	var _postfix = ".json";
	
	var _closure = {
		prefix: _prefix,
		postfix: _postfix,
	}
	
	with (_closure) {
	
		array_foreach(_files, function(_filename) {
			if (!string_starts_with(_filename, self.prefix)) {
				return;
			}
			if (!string_ends_with(_filename, self.postfix)) {
				return;
			}
			
			var _name = string_copy(
				_filename,
				string_length(self.prefix) + 1,
				string_length(_filename) - string_length(self.prefix) - string_length(self.postfix)
			)
			
			t_append_content__sync_include_file(_filename, _name);

		})
	
	}
	
}

function t_set_current_language(_current_language) {
	
	static _memory = (function() {
		t_static_validate_ready();
		return __t_memory();
	})();
	
	var _closure = {
		language: _current_language
	}
	
	with (_closure) {
		var _available_lancode_index = array_find_index(
			_memory.available_languages, 
			function(_value) {
				return _value == self.language;
			}
		);
		
		if (_available_lancode_index == -1) {
			return false;	
		}
		
		_memory.current_language = self.language;
	}
	
	return true;
	
}

function t_void(_key, _data=undefined, _arrayindex=-1) {
	
	static _memory = (function() {
		t_static_validate_ready();
		return __t_memory();
	})();
	
	var _language = _memory.current_language ?? _memory.default_language;
	
	var _translated = undefined;
	var _translate_lan = _memory.translate[$ _language];
	var _translate_lan_def = _memory.translate[$ _memory.default_language];
	
	if (is_struct(_translate_lan) && is_undefined(_translated)) {
		_translated = _translate_lan[$ _key];
	}
	if (is_struct(_translate_lan_def) && is_undefined(_translated)) {
		_translated = _translate_lan_def[$ _key];
	}
	if (is_undefined(_translated)) {
		return;
	}
	
	if (is_array(_translated)) {
		if (_arrayindex >= 0 && _arrayindex <= array_length(_translated) - 1) {
			_translated = _translated[_arrayindex];
		} else {
			_translated = script_execute_ext(choose, _translated);
		}
	}
	
	if (is_array(_data)) {
		return string_ext(_translated, _data);
	}
	
	return _translated;
	
}

function t(_key, _data=undefined, _arrayindex=undefined) {
	return t_void(_key, _data, _arrayindex) ?? _key;
}
