
GlobalService("camera").request(
	"set:angle", 
	GlobalService("camera").request("get:angle") + 1,
)
 