package ;

import buddy.*;
using buddy.Should;
using Std;

import simple.Monad;
using simple.monads.Option;



class OptionTest extends BuddySuite implements Buddy {
    public function new() {
        describe("Monad Computation of Option type", {
            it("Returning Some Value of Option type",{
                Monad.do_m(Option,{
                    x < Some(1);
                    y < Some("aa");
                    mPack(x.string()+y);
                }).string().should.be(
                    Some("1aa").string()
                );
            });

            it("Returning None of Option type",{
                Monad.do_m(Option,{
                    x < Some(1);
                    None;
                    mPack(x);
                }).string().should.be(
                    None.string()
                );
            });


        });
    }
}