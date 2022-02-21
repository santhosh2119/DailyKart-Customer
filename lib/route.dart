import 'package:flutter/material.dart';
import 'package:fooddelivery/ui/authentication/location_details_screen.dart';
import 'package:fooddelivery/ui/authentication/register_mobile_screen.dart';
import 'package:fooddelivery/ui/authentication/update_password_screen.dart';
import 'package:fooddelivery/ui/authentication/verificaion_code_screen.dart';
import 'package:fooddelivery/ui/authentication/web_view_component.dart';
import 'package:fooddelivery/ui/login/createaccount.dart';
import 'package:fooddelivery/ui/login/forgot_password_screen.dart';
import 'package:fooddelivery/ui/login/login_screen.dart';
import 'package:fooddelivery/ui/main/Delivery/delivery.dart';
import 'package:fooddelivery/ui/main/basket.dart';
import 'package:fooddelivery/ui/main/categoryDetails.dart';
import 'package:fooddelivery/ui/main/mainscreen.dart';
import 'package:fooddelivery/ui/main/productsDetails/dishesDetails.dart';
import 'package:fooddelivery/ui/main/restaurantDetails.dart';

class AppFoodRoute{

  Map<String, StatefulWidget> routes = {
    "/login" : LoginScreen(),
    VerificationCodeScreen.routeName : VerificationCodeScreen(),
    UpdatePasswordScreen.routeName : UpdatePasswordScreen(),
    RegisterMobileScreen.routeName:RegisterMobileScreen(),
    LocationDetailsScreen.routeName:LocationDetailsScreen(),
    WebViewComponent.routeName:WebViewComponent(),
    "/forgot" : ForgotPasswordScreen(),
    "/createaccount" : CreateAccountScreen(),
    "/main" : MainScreen(),
    DishesDetailsScreen.routeName : DishesDetailsScreen(),
    "/restaurantdetails" : RestaurantDetailsScreen(),
    "/categorydetails" : CategoryDetailsScreen(),
    "/basket" : BasketScreen(),
    "/delivery" : DeliveryScreen(),
  };

  //MainScreen mainScreen;
  List<StatefulWidget> _stack = List<StatefulWidget>();

  int _seconds = 0;

  disposeLast(){
    if (_stack.isNotEmpty)
      _stack.removeLast();
    _printStack();
  }

  setDuration(int seconds){
    _seconds = seconds;
  }
pushMaterialRoute(BuildContext _context,String name, MaterialPageRoute route){
  var _screen = routes[name];
  _stack.add(_screen);
  _printStack();
  Navigator.push(
    _context,
    route,

  );
  _seconds = 0;
}
  push(BuildContext _context, String name){
    var _screen = routes[name];
    // if (name == "/main")
    //   mainScreen = _screen;
    _stack.add(_screen);
    _printStack();
    Navigator.push(
      _context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: _seconds),
        pageBuilder: (_, __, ___) => _screen,
      ),
    );
    _seconds = 0;
  }

  pushToStart(BuildContext _context, String name) {
    var _screen = routes[name];
    // if (name == "/main")
    //   mainScreen = _screen;
    _stack.clear();
    _stack.add(_screen);
    _printStack();
    Navigator.pushAndRemoveUntil(
        _context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: _seconds),
          pageBuilder: (_, __, ___) => _screen,
        ),
        (route) =>route == null
    );
    _seconds = 0;
  }

  _printStack(){
    var str = "Screens Stack: ";
    for (var item in _stack)
      str = "$str -> $item";
    print(str);
  }

  pop(BuildContext context){
    Navigator.pop(context);
  }

  popToMain(BuildContext context){
    var _lenght = _stack.length;
    for (int i = 0; i < _lenght-1; i++) {
      if (Navigator.canPop(context))
        pop(context);
    }
  }

}