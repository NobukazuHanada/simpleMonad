package simple;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;
import haxe.macro.TypeTools;
import haxe.macro.Type;

using Lambda;
using haxe.macro.Tools;


class Monad{
	macro public static function do_m(type, e){
		return switch (e.expr) {
			case EBlock(exprArray):
			{expr : EBlock([(macro function mPack<T>( x : T ) return $type.mPack(x)),
							 do_arrayExpr(type, exprArray)]),
			pos : e.pos};
			case _: 
			Context.error("not block", Context.currentPos());
		}
	}

	#if macro
	private static function do_arrayExpr(type, exprArray : Array<Expr>){
		return if( exprArray.length == 1 ){
			exprArray[0];
		}else{
			var expr0 = exprArray[0];
			exprArray.remove(expr0);
			var rest = do_arrayExpr(type, exprArray);
			switch (expr0.expr) {
				case EBinop(OpLt, {expr : EConst(CIdent(varName)), pos : pos }, e2):
				macro $type.mBind($e2,function($varName)return $rest);
				case EVars(_):
				macro {$expr0; $rest;};
				case _:
				macro $type.mBind($expr0 ,function(_)return $rest);
			}
		}
	}
	#end

}