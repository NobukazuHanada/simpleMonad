package simple;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Type;

using Lambda;
using haxe.macro.TypeTools;


class Monad{
	macro public static function do_m(e){
		return switch (e.expr) {
			case EBlock(exprArray):
			var type = macro $i{checkType(exprArray)};
			{expr : EBlock([(macro function mPack<T>( x : T ) return $type.mPack(x)),
							 do_arrayExpr(type, exprArray)]),
			pos : e.pos};
			case _: 
			Context.error("not block", Context.currentPos());
		}
	}

	#if macro
	private static function checkType(exprs : Array<Expr>) : String{
		function typeToString(type:Type) : String{
			return switch(type){
				case TEnum(t,_): t.toString();
				case TType(t,_): t.toString();
				case _ : type.toString();
			}
		}


		var typeName = exprs.map(function(e)
			try{
				return switch (e.expr) {
					case EBinop(OpLt, _, e2):
						typeToString(Context.typeof(e2));
					case EVars(_):
						null;
					case _:
						typeToString(Context.typeof(e));
				}
			}
			catch(_:Dynamic){
				return null;
			})
		.fold(function(type,accType)
			return if(type == null) accType
			else { var typeDefName = type.split(".").pop(); typeDefName.substr(0, typeDefName.length - 3); }
		,null);

		return typeName;
	}
	#end

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