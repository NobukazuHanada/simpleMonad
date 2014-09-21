package simple.monads;

import simple.monads.Result.ResultDef;

enum ParseItem<S,T>{
	ParseItem(t:T,rest:S);
}

typedef ParseResult<S,E,T> = ResultDef<ParseItem<S,T>,E>;
typedef ParserDef<S,E,T> = S -> ParseResult<S,E,T>;

class Parser{
	public static function mPack<S,E,T>(tree : T) : ParserDef<S,E,T>
		return function(input : S) return Success(ParseItem(tree, input));


	public static function mBind<S,E,A,B>(m : ParserDef<S,E,A>, f : A -> ParserDef<S,E,B> ) : ParserDef<S,E,B>
		return function(input)
			return switch ( m(input) ) {
				case Success(ParseItem(tree, input)):
					f(tree)(input);
				case Error(x):  Error(x);
			}

	public static function or<S,E,T>(m1 : ParserDef<S,E,T>, m2 : ParserDef<S,E,T>) : ParserDef<S,E,T>
		return function(input)
			return switch (m1(input)) {
				case Error(_): m2(input);
				case result: result;
			}
	
	public static function and<S,E,T1,T2>(m1 : ParserDef<S,E,T1>, m2 : ParserDef<S,E,T2>) : ParserDef<S,E,T2>
		return function(input)
			return switch (m1(input)) {
				case Error(a): Error(a);
				case result : m2(input);
			}

	public static function many<S,E,T>(parser : ParserDef<S,E,T>)
        : ParserDef<S,E,Array<T>>
          return or(many1(parser),Parser.mPack([]));

    public static function many1<S,E,T>(parser : ParserDef<S,E,T>)
        : ParserDef<S,E,Array<T>>
          return Monad.do_m({
                  v < parser;
                  vs < many(parser);
                  mPack([v].concat(vs));
              });
}
