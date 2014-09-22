package ;

import buddy.*;
using buddy.Should;
using Std;
using simple.monads.Parser;

import simple.Monad;
import simple.monads.Parser;

typedef Input = String;

class ParserTest extends BuddySuite implements Buddy {
    public function new() {
        describe("Monad Computation of Parser type", {
            it("combinating item parsers",{
                function item(input:Input)
                    return if( input.length == 0 ) Error("don't get item!!!") 
                    else Success(ParseItem(input.charAt(0),input.substring(1)));

                var newParser = Monad.do_m({
                    x < item;
                    y < item;
                    mPack(x + y);
                });

                var result = newParser("12");
                switch (result) {
                    case Success(ParseItem(result,_)):
                    result.should.be("12");
                    case _:
                }

                var result2 = newParser("1");
                switch (result2) {
                    case Error(e): e.should.be("don't get item!!!");
                    case _ : 
                }

            });
        });
    }
}