
function winadaptive_calculate_by_width(_size_window, _size_view_width) {
	return {
		width: _size_view_width,
		height: _size_window.height / _size_window.width * _size_view_width,
	}
}

function winadaptive_calculate_by_height(_size_window, _size_view_height) {
	return {
		width: _size_window.width / _size_window.height * _size_view_height,
		height: _size_view_height,
	}
}

function winadaptive_calculate(_size_window, _size_view) {
	
	if (is_undefined(_size_view.width) && is_undefined(_size_view.height)) {
		throw ({
			message: "[o_game_service_camera] bad arguments",
		})
	}
	
	if (is_undefined(_size_view.width)) {
		var _by_height = 
			winadaptive_calculate_by_height(_size_window, _size_view.height);
		
		return {
			min: _by_height,
			max: _by_height,
		}
	}
	
	if (is_undefined(_size_view.height)) {
		var _by_width = 
			winadaptive_calculate_by_width(_size_window, _size_view.width);
		
		return {
			min: _by_width,
			max: _by_width,
		}
	}
	
	var _by_width = 
		winadaptive_calculate_by_width(_size_window, _size_view.width);
	var _by_height = 
		winadaptive_calculate_by_height(_size_window, _size_view.height);
	
	var _square_by_width = _by_width.width * _by_width.height;
	var _square_by_height = _by_height.width * _by_height.height;
	
	if (_square_by_width > _square_by_height) {
		return {
			min: _by_height,
			max: _by_width
		}
	} else {
		return {
			min: _by_width,
			max: _by_height
		}
	}
}

function winadaptive_calculate_inscribed_rectangle(_size_window, _size_inscribed_rectangle) {
	var _min_scale = min(
		_size_inscribed_rectangle.width / _size_window.width,
		_size_inscribed_rectangle.height / _size_window.height
	);
	
	return {
		width: _size_window.width * _min_scale,
		height: _size_window.height * _min_scale,
	}
}

