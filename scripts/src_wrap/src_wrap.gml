
function wrap(_number, _period) {
	return ((_number % _period) + _period) % _period;
}
