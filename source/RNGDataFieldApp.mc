import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class RNGDataFieldApp extends Application.AppBase {
    //the current random number
    var randomNumber;
    //the distance at which the next random number will be generated
    var regenDistance;
    //the minimum value of the rng
    var lowerBound;
    //whether or not the watch will vibrate on a new random number
    var vibrateOn;
    //the maximum value of the rng
    var upperBound;
    //if the watch uses km instead of mi
    var isMetric;
    //the fitfield used for recording the data into a graph for Garmin Connect
    var fitField;
    function initialize() {
        AppBase.initialize();
        //Get lower and upper bounds from properties
        if (Toybox.Application has :Properties) {
            lowerBound = Application.Properties.getValue("lowerBound");
            upperBound = lowerBound + Application.Properties.getValue("range") - 1;
            vibrateOn = Application.Properties.getValue("vibrate");
        }
        else {
            lowerBound = getProperty("lowerBound");
            upperBound = lowerBound + getProperty("range") - 1;
            vibrateOn = getProperty("vibrate");
        }

        //initialize more stuff
        isMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
        randomNumber = Random.randInt(lowerBound, upperBound);
        regenDistance = .1 * randomNumber;
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new RNGDataFieldView() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as RNGDataFieldApp {
    return Application.getApp() as RNGDataFieldApp;
}