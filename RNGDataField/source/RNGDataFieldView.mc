import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
import Random;
import Toybox.System;
import Toybox.Application;
import Toybox.Math;

class RNGDataFieldView extends WatchUi.SimpleDataField {
    var randomNumber;
    var startDistance;
    var lowerBound;
    var upperBound;
    var isMetric;
    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Random Num";
        isMetric = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC;
        if (Toybox.Application has :Properties) {
            lowerBound = Application.Properties.getValue("lowerBound");
            upperBound = lowerBound + Application.Properties.getValue("range") - 1;
        }
        else {
            var app = Application.getApp();
            lowerBound = app.getProperty("lowerBound");
            upperBound = lowerBound + app.getProperty("range") - 1;
        }
        randomNumber = Random.randInt(lowerBound, upperBound);
        startDistance = 0;


    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
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
        // See Activity.Info in the documentation for available information.
        if (convertedDistance >= startDistance + .1 * randomNumber) {
            //attempt to adjust for accumulated errors by rounding to nearest 10th
            startDistance = Math.round(convertedDistance * 10) / 10;
            randomNumber = Random.randInt(lowerBound, upperBound);
        }
        return randomNumber;
    }

}