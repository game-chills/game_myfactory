
function draw_sprite_to_rectangle(_sprite, _subimg, _x, _y, _w, _h, _color=c_white, _alpha=1) {
	
	var _x1 = _x;
	var _y1 = _y;
	
	var _ww = _w;
	var _hh = _w;
	
	var _sprite_ww = sprite_get_width(_sprite);
	var _sprite_hh = sprite_get_height(_sprite);
	
	var _sx;
	var _sy;
	var _sw;
	var _sh;
	
	if (_sprite_ww > _sprite_hh) {
		_sx = _x1;
		_sw = _ww;
		
		_sh = min(
			_sprite_hh / _sprite_ww * _ww,
			_sprite_hh / _sprite_ww * _hh,
		)
		_sy = _y1 + (_hh - _sh) / 2;
	} else {
		_sy = _y1;
		_sh = _hh;
		
		_sw = min(
			_sprite_ww / _sprite_hh * _hh,
			_sprite_ww / _sprite_hh * _ww,
		)
		_sx = _x1 + (_ww - _sw) / 2;	
	}
	
	draw_sprite_stretched_ext(
		_sprite,
		_subimg,
		_sx,
		_sy,
		_sw,
		_sh,
		_color,
		_alpha
	)
	
}
