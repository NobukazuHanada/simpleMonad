package simple.monads;

enum Cont<R,A>{
	Cont( cont : (A -> R) -> R );
}

class Continuation{
	public static function runCont<R,A>(m : Cont<R,A>, f : A -> R) : R{
		return switch (m) {
			case Cont(c):
			c(f);
		}
	}

	public static function callCC(f){
		return Cont(function(k) return runCont(f(function(a) return Cont(function(_) return k(a))),k));
	}

	public static function mPack<R,A>(a : A) : Cont<R,A>{
		return Cont(function(k)return k(a));
	}

	public static function mBind<R,A,B>(m : Cont<R,A>, f : A -> Cont<R,B>) : Cont<R,B>{
		return Cont(function(k)return runCont(m, function(a)return runCont(f(a),k)));
	}
}