
if (is_struct(loading_parts)) {
	return;
}

if (time_current < 0) {
	return;	
}

--time_current;

if (time_current < 0) {
	event_user(0);
}
