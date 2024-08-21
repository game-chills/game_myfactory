enum StateMachineEvflowKind {
	outside,
	in,
	inside,
	out,
}

function StateMachineEvflowReader(_base) constructor {
	
    #region __constructor
	{
	    self._kind_ref = 
			is_numeric(_base) 
			? { ref: { value: _base } } 
			: _base;
	}
	#endregion
	
	function get_kind() {
		return self._kind_ref.ref.value;
	}
	
	function get_kind_name() {
		switch (self.get_kind()) {
			case StateMachineEvflowKind.outside:
				return "outside";
			case StateMachineEvflowKind.in:
				return "in";
			case StateMachineEvflowKind.inside:
				return "inside";
			case StateMachineEvflowKind.out:
				return "out";
		}
	}
	
	function is_outside() {
        return self.get_kind() == StateMachineEvflowKind.outside;
    }
	
	function is_in() {
	    return self.get_kind() == StateMachineEvflowKind.in;
	}
	
	function is_inside() {
	    return self.get_kind() == StateMachineEvflowKind.inside;
	}
	
	function is_out() {
	    return self.get_kind() == StateMachineEvflowKind.out;
	}
	
	function is_active() {
	    return
	        self.get_kind() == StateMachineEvflowKind.in ||
	        self.get_kind() == StateMachineEvflowKind.inside;
	}
	
	function is_inactive() {
	    return
	        self.get_kind() == StateMachineEvflowKind.out ||
	        self.get_kind() == StateMachineEvflowKind.outside;
	}
	
	function toString() {
		return string("StateMachineEvflow(\"{0}\")", self.get_kind_name());
	}

}


function StateMachineEvflow() 
	: StateMachineEvflowReader(StateMachineEvflowKind.outside) constructor {
	
    function input(_has_emit) {
	    switch (self.get_kind()) {
	        case StateMachineEvflowKind.outside: {
	            if (_has_emit) {
	                self._kind_ref.ref.value = StateMachineEvflowKind.in;
	            } else {
	            	self._kind_ref.ref.value = StateMachineEvflowKind.outside;
	            }
	            break;
	        }
	        case StateMachineEvflowKind.in: {
	            if (_has_emit) {
	                self._kind_ref.ref.value = StateMachineEvflowKind.inside;
	            } else {
	                self._kind_ref.ref.value = StateMachineEvflowKind.out;
	            }
	            break;
	        }
	        case StateMachineEvflowKind.inside: {
	        	if (_has_emit) {
	        		self._kind_ref.ref.value = StateMachineEvflowKind.inside;
	        	} else {
	                self._kind_ref.ref.value = StateMachineEvflowKind.out;
	            }
	            break;
	        }
	        case StateMachineEvflowKind.out: {
	        	if (_has_emit) {
	        		self._kind_ref.ref.value = StateMachineEvflowKind.in;
	        	} else {
	                self._kind_ref.ref.value = StateMachineEvflowKind.outside;
	            }
	            break;
	        }
	    }
	    return self._kind_ref.ref.value;
	}
	
	function reset() {
		 self._kind_ref.ref.value = StateMachineEvflowKind.outside;
	}
	
	function build_reader() {
		
		// you need control lifetime variables
		
		var _weak_ref = weak_ref_create(self._kind_ref.ref);
		var _reader = new StateMachineEvflowReader(_weak_ref);
		
		return _reader;
		
	}
	
}
