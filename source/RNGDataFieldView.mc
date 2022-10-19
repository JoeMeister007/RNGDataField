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
    var app;
    function initialize() {
        //initialize and set label
        SimpleDataField.initialize();
        label = "Random Num";
        app = Application.getApp();
        //create fitfield
        if (app.fitField == null) {
            app.fitField = createField("Random Number", 0, FitContributor.DATA_TYPE_FLOAT, 
            {:mesgType => FitContributor.MESG_TYPE_RECORD});
        }
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        //Convert the distance from meters to km or miles
        System.println(info.elapsedDistance);
        var convertedDistance = info.elapsedDistance;
        if (convertedDistance == null) {
            return app.randomNumber;
        }
        if (app.isMetric) {
            convertedDistance /= 1000;
        }
        else {
            convertedDistance /= 1609.34;
        }
        
        if (convertedDistance >= app.regenDistance) {
            //regenerate a random number and attempt to adjust for accumulated errors by rounding to 
            //nearest 10th
            app.randomNumber = Random.randInt(app.lowerBound, app.upperBound);
            app.regenDistance = Math.round(app.regenDistance * 10 + app.randomNumber) / 10;

            if (app.vibrateOn && Attention has :vibrate) {
                //vibrate at 100% power for 1 second
                Attention.vibrate([new Attention.VibeProfile(100, 1000)]);
            }
        }
        //update the field to display in the graph and return the number
        app.fitField.setData(app.randomNumber);
        return app.randomNumber;
    }

}