
t_static_set_available_languages(["ru", "en"]);
t_static_set_default_language("en");

t_static_validate_ready();

t_append_content__sync_include_files("translate", [
	"translate.menu.json"
]);

t_set_current_language("en");

instance_destroy();
