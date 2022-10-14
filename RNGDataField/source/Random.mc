import Toybox.Math;
import Toybox.Lang;
module Random {
    //Returns a random integer from lower to upper inclusive. No Bounds checking is performed.
    function randInt(lower, upper) {
        return (Math.rand() % (upper - lower + 1) + lower);
    }
}
