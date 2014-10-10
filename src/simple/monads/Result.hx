package simple.monads;

enum ResultDef<R,L>{
	Success(r:R);
	Error(l:L);
}

class Result{
	public static function mPack<R,L>(r : R) : ResultDef<R,L> return Success(r);
	
	public static function mBind<R1,R2,L>(m : ResultDef<R1,L> , f : R1 -> ResultDef<R2,L>){
		return switch (m) {
			case Success(r): f(r);
			case Error(e): Error(e);	
		}
	}
}