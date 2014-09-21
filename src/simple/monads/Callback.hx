package simple.monads;

typedef Handler<R,A> = (A -> R) -> R;
typedef Handler2<R,A,B> = (A -> B -> R) -> R;
typedef Tuple2<A,B> = {one : A, two : B};

class Callback{
	public static function toHandler1<A,B,R>(func : Handler2<R,A,B>) : Handler<R, Tuple2<A,B>>{
		return function(callback)
			return func(function(one, two)
				return callback({one : one, two : two}));
	}

	public static function mPack<R,A>(x : A) : Handler<R,A>{
		return function(r) return r(x);
	}

	public static function mBind<R,A,B>(m : Handler<R,A>, f : A -> Handler<R,B>) : Handler<R,B>{
		return function(b) return m(function(a) return f(a)(b));
	}
}