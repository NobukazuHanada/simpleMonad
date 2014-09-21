package simple.monads;

enum ResultDef<R,L>{
	Success(r:R);
	Error(l:L);
}

class Result{
	public static function mPack(r) return Success(r);
	
	public static function mBind(m , f){
		return switch (m) {
			case Success(r):
			f(r);
			case Error(_):
			m;
		}
	}
}