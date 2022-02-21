import 'dart:async';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/notification.dart';
import 'package:fooddelivery/ui/authentication/location_details_screen.dart';
import 'package:fooddelivery/ui/login/createaccount.dart';
import 'package:fooddelivery/widget/ibackground4.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  ////////////////////////////////////////////////////////////////
  //
  //
  //
  _startNextScreen(){
    route.setDuration(1);
    int stepsCompleted = PreferenceHelper.getInt(AppConstants.PREF_STEPS_COMPLETED);
    Fimber.d("stepsCompleted : $stepsCompleted");

    //route.pushToStart(context,CreateAccountScreen.routeName);

    if(stepsCompleted == 4){
      route.pushToStart(context, "/main");
    }/*else if(stepsCompleted == 2){
      route.pushToStart(context, LocationDetailsScreen.routeName);
    }*/
    else {
      route.pushToStart(context, "/login");
    }

    //route.pushToStart(context, LocationDetailsScreen.routeName);


  }
  //
  //
  ////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    pref.init();
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      await firebaseGetToken(context);
    });
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, _startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: initScreen(context),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[

            Container(
              color: theme.colorBackground,
            ),

            // if (theme.appTypePre != "multivendor")
            IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
            //
            // if (theme.appTypePre == "multivendor")
            //   Container(
            //     width: windowWidth,
            //     height: windowHeight,
            //     decoration: BoxDecoration(
            //         // borderRadius: BorderRadius.circular(_radius),
            //         gradient: RadialGradient(
            //           colors: theme.colorsVendorGradient,
            //           radius: 4,
            //         )),
            //   ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "SplashLogo",
                    child: Container(
                      width: windowWidth*0.75,
                      child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: windowWidth * 0.05)),
                  CircularProgressIndicator(
                    backgroundColor: theme.colorCompanion,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 1,
                  )
                ],
              ),
            ),


          ],
        )

    );
  }

}


