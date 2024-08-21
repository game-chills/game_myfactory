

draw_set_color(c_black);
draw_set_alpha(1);

draw_text(
	x, y,
	o_game_service_yagames.language,
);

draw_text(
	x, y + 64,
	o_game_service_yagames.authorization_id,
);

draw_text(
	x, y + 128,
	o_game_service_yagames.authorization_name,
);

draw_text(
	x, y + 192,
	o_game_service_yagames.authorization_signature,
);