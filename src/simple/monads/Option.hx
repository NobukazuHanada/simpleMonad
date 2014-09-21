package simple.monads;

enum OptionDef<T>{
	Some(i:T);
	None;
}

class Option{
	public static function mPack
		<A>(a : A) : OptionDef<A>
		return Some(a);

	public static function mBind
		<A,B>(m : OptionDef<A>,
			  f : A -> OptionDef<B>) : OptionDef<B>
		return switch(m){
			case Some(a) : f(a);
			case None : None;
		};
}