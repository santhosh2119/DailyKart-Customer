import 'package:flutter/material.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/model/account.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/pref.dart';
import 'package:fooddelivery/route.dart';
import 'package:fooddelivery/config/theme.dart';
import 'package:fooddelivery/ui/login/login_screen.dart';
import 'package:fooddelivery/ui/start/splash.dart';
import 'config/lang.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fimber/fimber.dart';

import 'model/dprint.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
//
// Language data
//
Lang strings = Lang();
//
// Routes
//
AppFoodRoute route = AppFoodRoute();
//
// Account
//
Account account = Account();
Pref pref = Pref();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // plant a tree - DebugTree()
  await PreferenceHelper.getInstance();
  Fimber.plantTree(DebugTree());
  await Firebase.initializeApp();
  pref.init().then((instance) {
    appSettings.bottomBarType = pref.get(Pref.bottomBarType);

    var dark = pref.get(Pref.uiDarkMode);
    if (dark == "true")
      theme.darkMode = true;
    var colorMain = pref.get(Pref.uiMainColor);
    if (colorMain.isNotEmpty)
      theme.colorPrimary = Color(int.parse(colorMain, radix: 16));
    theme.init();

    var id = pref.get(Pref.language);
    var lid = Lang.english;
    if (id.isNotEmpty)
      lid = int.parse(id);
    strings.setLang(lid);  // set default language - English
    runApp(AppFoodDelivery());
  });
}

class AppFoodDelivery  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var _theme = ThemeData(
      fontFamily: 'Nunito-Regular',
      primarySwatch: theme.primarySwatch,
      accentColor: theme.colorPrimary,
      textTheme: TextTheme(
        button: TextStyle(color: Colors.black),
      ),
    );

    if (theme.darkMode){
      _theme = ThemeData(
        fontFamily: 'Nunito-Regular',
        brightness: Brightness.dark,
        unselectedWidgetColor:Colors.white,
        primarySwatch: theme.primarySwatch,
        textTheme: TextTheme(
        ).apply(
          bodyColor: Colors.white,
        ),
      );
    }

    dprint("Server path: $serverPath");
    dprint(theme.appTypePre);

    return MaterialApp(
      title: strings.get(10),  // "Food Delivery Flutter App UI Kit",
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
      },
    );
  }
}



