import 'dart:convert';
import 'dart:io';
//86575 66287
//electronics.returns@tatacliq.com
import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/request/LoginRequest.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/login.dart';
import 'package:fooddelivery/model/server/register.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:fooddelivery/ui/authentication/register_mobile_screen.dart';
import 'package:fooddelivery/ui/authentication/verificaion_code_screen.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iappBar.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/ibutton4.dart';
import 'package:fooddelivery/widget/iinputField2PasswordA.dart';
import 'package:fooddelivery/widget/iinputField2a.dart';
/*import 'package:apple_sign_in/apple_sign_in.dart';*/
import 'otp.dart';

class LoginScreen extends StatefulWidget {
  static  const String routeName="/login";
  final String extraData;
  const LoginScreen({Key key,this.extraData}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _pressLoginButton(){
    Fimber.d("User pressed \"LOGIN\" button");
    Fimber.d("Login1: ${editControllerName.text}, password: ${editControllerPassword.text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(172)); // "Enter Login",
    /*if (!validateEmail(editControllerName.text))
      return openDialog(strings.get(174)); */
    if (editControllerPassword.text.isEmpty)
      return openDialog(strings.get(173)); // "Enter Password",

    _socialEnter = false;
    //login(editControllerName.text, editControllerPassword.text, _okUserEnter, _error);
    _validateLogin();
  }
  _validateLogin(){
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        var mobileNo = editControllerName.text.toString();
        var password = editControllerPassword.text.toString();
       // password = "test%401234";


        LoginRequest loginRequest = new LoginRequest(
            password: password,
            mobile: mobileNo,
          firebaseToken: PreferenceHelper.getString(AppConstants.PREF_FCM_TOKEN)
           );
      //  var requestBody = jsonEncode(loginRequest);
       // Fimber.d("Request Data : $requestBody");
       // var dataa = FormData.fromMap(loginRequest);
        CommonMethods.getApiRepository().getLoginDetails(loginRequest.toMap()).then((response) {
          Fimber.d("Login Success");
          //_popDialog();
          //DialoguesUtils.hideProgressbar(context);
          if (response != null) {
            if(response.status == true){
              PreferenceHelper.setString(AppConstants.PREF_PASSWORD, password);

             /* route.pushMaterialRoute(context, VerificationCodeScreen.routeName  ,MaterialPageRoute(
                builder: (context) => VerificationCodeScreen(extraData: response.message,newUser: false,),
              ));*/

              route.pushToStart(context, "/main");
            }else{
              openDialog( response.message);
              //DialoguesUtils.showMessageDialogue(context: context,message: response.message);
            }

          //  navigateUser(response);
          }
        },
          onError: (exception) {
            _popDialog();
            CommonMethods.manageError(context, exception);
          },
        );

        //DialoguesUtils.showProgressbar(context: context);
        _waits(true);

      } else {
        // No-Internet Case
        Fimber.d("isNetwork Not Available");
        //openDialog(AppConstants.msgNoInternet);
        DialoguesUtils.noInternet(context);
      }
    });
  }

  var _socialEnter = false;
  var _socialId = "";
  var _socialType = "";
  var _socialName = "";
  var _socialPhoto = "";


  _pressDontHaveAccountButton(){
    print("User press \"Don't have account\" button");
    //route.push(context, "/createaccount");
    route.push(context, RegisterMobileScreen.routeName);
  }

  _pressForgotPasswordButton(){
    print("User press \"Forgot password\" button");
    route.push(context, "/forgot");
  }
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();
  bool _wait = false;
  ScrollController _scrollController = ScrollController();

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _error(String error){
    _waits(false);
    if (error == "login_canceled")
      return;
    if (error == "1") {
      if (_socialEnter){
        if (appSettings.otp == "true")
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                  name: _socialName,
                  email: "$_socialId@$_socialType.com",
                  type: _socialType,
                  password: _socialId,
                  photo: _socialPhoto
              ),
            ),
          );
        return register("$_socialId@$_socialType.com", _socialId, _socialName, _socialType, _socialPhoto, _okUserEnter2, _error);
      }
      return openDialog(strings.get(174)); // "Login or Password in incorrect"
    }
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _okUserEnter2(String name, String password, String avatar, String email, String token, String typeReg){
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, "", 0, typeReg);
    route.pushToStart(context, "/main");
  }

  //This method hide dialog in this screen
  _popDialog(){
    _waits(false);
    route.pop(context);
  }
  _okUserEnter(String name, String password, String avatar, String email, String token, String _phone, int i, String typeReg){
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, _phone, i, typeReg);
    route.pop(context);
  }

  @override
  void initState() {
    _initiOS();
    if(widget.extraData!=null && widget.extraData.isNotEmpty){
      openDialog(widget.extraData);
    }
    super.initState();
  }

  _initiOS(){
    if(Platform.isIOS) {
     /* AppleSignIn.onCredentialRevoked.listen((_) {
        dprint("Credentials revoked");
      });*/
    }
  }

  /*_buttoniOS(){
    if(Platform.isIOS) {
      return FutureBuilder<bool>(
          future: _isAvailableFuture,
          builder: (context, isAvailableSnapshot) {
            if (!isAvailableSnapshot.hasData) {
              return Container();
            }
            return isAvailableSnapshot.data
                ? Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: IButton4(
                    color: Color(0xff000000), text: strings.get(298), textStyle: theme.text14boldWhite,  // "Log In with Apple",
                    icon: "assets/apple.png",
                    pressButton: (){
                      _waits(true);
                      appleLogin.login(_login, _error);
                    }))
                : null; // 'Sign in With Apple not available. Must be run on iOS 13+
          });
    }else{
      return Container();
    }
  }*/

  /*final Future<bool> _isAvailableFuture = AppleSignIn.isAvailable();*/

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: windowWidth,
            child: _body(),
           ),

          if (_wait)(
              Container(
                color: Color(0x80000000),
                width: windowWidth,
                height: windowHeight,
                child: Center(
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),
              ))else(Container()),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

         // IAppBar(context: context, text: "", color: Colors.white),

        ],
      ),
    ));
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  _body(){
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[

        Container(
          width: windowWidth*0.4,
          height: windowWidth*0.4,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),

        SizedBox(height: 20,),

        SizedBox(height: 15,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_enter_mobile_no ,            // "Login"
              icon: Icons.mobile_friendly_sharp,
              colorDefaultText: Colors.white,
              controller: editControllerName,
              type: TextInputType.phone,
              maxLength: 10,
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2PasswordA(
              hint: strings.get(16),            // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword,
            )),

        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 30,),

        Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: IButton3(
                color: theme.colorCompanion, text: strings.get(22), textStyle: theme.text14boldWhite,  // LOGIN
                pressButton: (){
                  _pressLoginButton();
                })),

        SizedBox(height: 25,),

        InkWell(
            onTap: () {
              _pressDontHaveAccountButton();
            }, // needed
            child:Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
              child: Text(strings.get(19),                    // ""Don't have an account? Create",",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite
              ),
            )),
        InkWell(
            onTap: () {
              _pressForgotPasswordButton();
            }, // needed
            child:Container(
              padding: EdgeInsets.all(20),
              child: Text(strings.get(17),                    // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite
              ),
            ))

      ],
    );
  }
}