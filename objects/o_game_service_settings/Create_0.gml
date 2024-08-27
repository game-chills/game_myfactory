/* 
 * for local storage,
 * dont clouds
 *
 * sync thread blocking
 */


/* state */

flag_audio_active = true;
flag_audio_active_music = true;
flag_audio_active_sound = true;

/* methods */

settings_load = function() {
	/* this method is sync blocked */
	
	ini_open("settings");
	try {
		
		var _audio_active = ini_read_real("audio", "active", 1);
		var _audio_music_active = ini_read_real("audio", "music_active", 1);
		var _audio_sound_active = ini_read_real("audio", "sound_active", 1);
		
		flag_audio_active = !!_audio_active;
		flag_audio_active_music = !!_audio_music_active;
		flag_audio_active_sound = !!_audio_sound_active;
		
	} finally {
		ini_close();
	}
	
}

settings_save = function() {
	/* this method is sync blocked */
	
	ini_open("settings");
	try {
		
		ini_write_real("audio", "active", real(flag_audio_active));
		ini_write_real("audio", "music_active", real(flag_audio_active_music));
		ini_write_real("audio", "sound_active", real(flag_audio_active_sound));
		
	} finally {
		ini_close();
	}
	
}

/* service providers */

GlobalService("settings:sound").provider("get:active", function() {
	return flag_audio_active;
})
GlobalService("settings:sound").provider("get:active:music", function() {
	return flag_audio_active && flag_audio_active_music;
})
GlobalService("settings:sound").provider("get:active:sound", function() {
	return flag_audio_active && flag_audio_active_sound;
})

GlobalService("settings:sound").provider("set:active", function(_active) {
	
	flag_audio_active = bool(_active);
	
	alarm_set(0, 2);
	
})
GlobalService("settings:sound").provider("set:active:music", function(_active) {
	
	flag_audio_active_music = bool(_active);
	
	alarm_set(0, 2);
	
})
GlobalService("settings:sound").provider("set:active:sound", function(_active) {
	
	flag_audio_active_sound = bool(_active);
	
	alarm_set(0, 2);
	
})

/* init */

settings_load();
settings_save();
