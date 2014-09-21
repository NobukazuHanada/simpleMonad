package simple.monads;

typedef StateResult<S, V> = {
	state : S,
	result : V
}

enum StateDef<S,T>{
	State(transition : S ->  StateResult<S,T> );
}


class State{
	public static function transit<S,T>(m : StateDef<S,T>, value : S){
		return switch (m) {
			case State(transition):
			transition(value);
		}
	}

	public static function mPack(x){
		return State(function(s){ return {state : s, result : x}; });
	}

	public static function mBind<S,A,B>(m : StateDef<S,A>, f : A -> StateDef<S,B>){
		return State(function(s){
			return switch (transit(m,s)) {
				case {state : newS, result : v}:
				transit(f(v),newS);
			};
		});
	}
}