
/* pause */

pause = true;

GlobalService("pause").request("on:transition:instance:variable", {
	instance: id,
	variable: "pause",
});
