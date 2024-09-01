
/* ui menu render */

if (!ui.visible) {
	return;
}

var _layer = ui.layer;
var _components = ui.elements[$ _layer];
	
if (!is_array(_components)) {
	return;	
}

var _length = array_length(_components);
var _component;
for (var i = 0; i < _length; ++i) {
	_component = _components[i];
			
	if (_component.type == "button") {
		
		draw_set_font(_component.state.font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		
		if (_component.state.type == "none") {
			
			draw_set_color(_component.params.text_base_color);
			draw_set_alpha(ui.draw.alpha);
			
			draw_text(
				_component.state.xc,
				_component.state.yc,
				_component.state.text
			);
			
			continue;
		}
		
		if (_component.state.type == "hover") {
			
			draw_sprite_stretched_ext(
				s_menu_button,
				0,
				_component.state.x1,
				_component.state.y1,
				_component.state.width,
				_component.state.height,
				c_black,
				0.5 * ui.draw.alpha,
			);
			
			draw_set_color(c_white);
			draw_set_alpha(ui.draw.alpha);
			
			draw_text(
				_component.state.xc,
				_component.state.yc,
				_component.state.text
			);
			
			continue;
		}
		
		draw_sprite_stretched_ext(
			s_menu_button,
			0,
			_component.state.x1 + 4,
			_component.state.y1 + 4,
			_component.state.width,
			_component.state.height,
			c_gray,
			0.5 * ui.draw.alpha,
		);
			
		draw_set_color(c_dkgray);
		draw_set_alpha(ui.draw.alpha);
		
		draw_text(
			_component.state.xc,
			_component.state.yc,
			_component.state.text
		);
		
		draw_set_color(c_white);
		draw_text(
			_component.state.xc + 4,
			_component.state.yc + 4,
			_component.state.text
		);
		
		continue;
		
	}

	if (_component.type == "button-icon") {
		
		draw_set_font(_component.state.font);
		draw_set_halign(fa_left);
		draw_set_valign(fa_center);
		
		if (_component.state.type == "none") {
			
			draw_set_color(_component.params.text_base_color);
			draw_set_alpha(ui.draw.alpha);
			
			draw_text(
				_component.state.tx,
				_component.state.ty,
				_component.state.text
			);
			
			if (!is_undefined(_component.state.isprite)) {
			
				draw_sprite_to_rectangle(
					_component.state.isprite,
					_component.state.isubimg,
					_component.state.ix1,
					_component.state.iy1,
					_component.state.ix2 - _component.state.ix1,
					_component.state.iy2 - _component.state.iy1,
					c_white,
					ui.draw.alpha
				);
			
			}
			
			continue;
		}
		
		if (_component.state.type == "hover") {
			
			draw_sprite_stretched_ext(
				s_menu_button,
				0,
				_component.state.x1,
				_component.state.y1,
				_component.state.width,
				_component.state.height,
				c_black,
				0.5 * ui.draw.alpha,
			);
			
			draw_set_color(c_white);
			draw_set_alpha(ui.draw.alpha);
			
			draw_text(
				_component.state.tx,
				_component.state.ty,
				_component.state.text
			);
			
			if (!is_undefined(_component.state.isprite)) {
			
				draw_sprite_to_rectangle(
					_component.state.isprite,
					_component.state.isubimg,
					_component.state.ix1,
					_component.state.iy1,
					_component.state.ix2 - _component.state.ix1,
					_component.state.iy2 - _component.state.iy1,
					c_white,
					ui.draw.alpha
				);
			
			}
			
			continue;
		}
		
		draw_sprite_stretched_ext(
			s_menu_button,
			0,
			_component.state.x1 + 4,
			_component.state.y1 + 4,
			_component.state.width,
			_component.state.height,
			c_gray,
			0.5 * ui.draw.alpha,
		);
			
		draw_set_color(c_dkgray);
		draw_set_alpha(ui.draw.alpha);
		
		draw_text(
			_component.state.tx,
			_component.state.ty,
			_component.state.text
		);
		
		draw_set_color(c_white);
		draw_text(
			_component.state.tx + 4,
			_component.state.ty + 4,
			_component.state.text
		);
		
		if (!is_undefined(_component.state.isprite)) {
			
			draw_sprite_to_rectangle(
				_component.state.isprite,
				_component.state.isubimg,
				_component.state.ix1 + 4,
				_component.state.iy1 + 4,
				_component.state.ix2 - _component.state.ix1,
				_component.state.iy2 - _component.state.iy1,
				c_white,
				ui.draw.alpha
			);
			
		}
		
		continue;
		
	}
	
	if (_component.type == "text") {
		
		draw_set_font(_component.state.font);
		draw_set_halign(_component.halign);
		draw_set_valign(_component.valign);
		draw_set_color(c_black);
		draw_set_alpha(ui.draw.alpha);
		
		draw_text(
			_component.state.xc,
			_component.state.yc,
			_component.state.text
		);
		
		continue;
		
	}

}
