import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
import Random;
import Toybox.System;
import Toybox.Application;
import Toybox.Math;
import Toybox.Attention;
import Toybox.FitContributor;

class RNGDataFieldView extends WatchUi.SimpleDataField {
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
        //initialize and set label
        SimpleDataField.initialize();
        label = "Random Num";
        isMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
        //Get lower and upper bounds from properties
        if (Toybox.Application has :Properties) {
            lowerBound = Application.Properties.getValue("lowerBound");
            upperBound = lowerBound + Application.Properties.getValue("range") - 1;
            vibrateOn = Application.Properties.getValue("vibrate");
        }
        else {
            var app = Application.getApp();
            lowerBound = app.getProperty("lowerBound");
            upperBound = lowerBound + app.getProperty("range") - 1;
            vibrateOn = app.getProperty("vibrate");
        }
        //create fit field
        fitField = createField("Random Number", 0, FitContributor.DATA_TYPE_FLOAT, 
        {:mesgType => FitContributor.MESG_TYPE_RECORD});
        //initialize more stuff
        randomNumber = Random.randInt(lowerBound, upperBound);
        regenDistance = .1 * randomNumber;


    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        //Convert the distance from meters to km or miles
        System.println(info.elapsedDistance);
        var convertedDistance = info.elapsedDistance;
        if (convertedDistance == null) {
            return randomNumber;
        }
        if (isMetric) {
            convertedDistance /= 1000;
        }
        else {
            convertedDistance /= 1609.34;
        }
        
        if (convertedDistance >= regenDistance) {
            //regenerate a random number and attempt to adjust for accumulated errors by rounding to 
            //nearest 10th
            randomNumber = Random.randInt(lowerBound, upperBound);
            regenDistance = Math.round(regenDistance * 10 + randomNumber) / 10;

            if (vibrateOn && Attention has :vibrate) {
                //vibrate at 100% power for 1 second
                Attention.vibrate([new Attention.VibeProfile(100, 1000)]);
            }
        }
        //update the field to display in the graph and return the number
        fitField.setData(randomNumber);
        return randomNumber;
    }

}