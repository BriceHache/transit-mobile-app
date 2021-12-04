import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:easy_localization/easy_localization.dart';
class Reminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        SizedBox(
          height: 200,
          child: AnalogClock(
            
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.white),
              color: Colors.transparent,
              shape: BoxShape.circle),
          width: 200.0,
          isLive: true,
          hourHandColor: Colors.white,
          minuteHandColor: Colors.white,
          showSecondHand: true,
          numberColor: Colors.white,
          showNumbers: true,
          textScaleFactor: 1.4,
          showTicks: true,
          digitalClockColor: Colors.white,
          showDigitalClock: true,
          datetime: DateTime(2019, 1, 1, 9, 12, 15),
	      ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'reminder_msg'.tr(),
                  //"Meditate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  //"06:12 PM",
                  'daily_reminder'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            
          ],
        )
      ],
    );
  }
}
