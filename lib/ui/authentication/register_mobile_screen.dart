import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/request/LoginRequest.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/register.dart';
import 'package:fooddelivery/ui/authentication/location_details_screen.dart';
import 'package:fooddelivery/ui/authentication/verificaion_code_screen.dart';
import 'package:fooddelivery/ui/login/login_screen.dart';
import 'package:fooddelivery/ui/login/needAuth.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iappBar.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinputField2PasswordA.dart';
import 'package:fooddelivery/widget/iinputField2a.dart';

class RegisterMobileScreen extends StatefulWidget {
  static  const String routeName="/register";
  const RegisterMobileScreen({Key key}) : super(key: key);

  @override
  _RegisterMobileScreenState createState() => _RegisterMobileScreenState();
}

class _RegisterMobileScreenState extends State<RegisterMobileScreen>  with SingleTickerProviderStateMixin  {
  _pressSendOtpButton(){
    Fimber.d("User pressed \"SEND OTP\" button");

    if (editControllerName.text.isEmpty)
      return openDialog("Please enter mobile no"); // "Enter Login",
    if(editControllerName.text.length!=10){
      return openDialog("Please enter valid mobile no"); // "Enter Login",
    }
    /*if (!validateEmail(editControllerName.text))
      return openDialog(strings.get(174)); */



    //login(editControllerName.text, editControllerPassword.text, _okUserEnter, _error);
    _validateMobileNo();
  }
  _validateMobileNo(){
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        var mobileNo = editControllerName.text.toString();
        //var password = editControllerPassword.text.toString();
        // password = "test%401234";


        var body =
        {
          'mobile': '$mobileNo'
        };

      /*  LoginRequest loginRequest = new LoginRequest(  mobile: mobileNo,
        );*/
        //  var requestBody = jsonEncode(loginRequest);
        // Fimber.d("Request Data : $requestBody");
        // var dataa = FormData.fromMap(loginRequest);
        CommonMethods.getApiRepository().validateMobileNo(body).then((response) {
          Fimber.d("Login Success");
          _waits(false);
          //_popDialog();
          //DialoguesUtils.hideProgressbar(context);
          if (response != null) {
            PreferenceHelper.setInt(AppConstants.PREF_STEPS_COMPLETED, response.stepsCompleted);
            PreferenceHelper.setString(AppConstants.PREF_MOBILE,   mobileNo);
            if(response.isRegistered == true){
              //TODO ::  here need to manage based on steps
              /*if(response.stepsCompleted == 4){
                route.push(context, LoginScreen.routeName);
              }else{
                route.push(context, LocationDetailsScreen.routeName);
              }*/
              route.pushMaterialRoute(context, LoginScreen.routeName  ,MaterialPageRoute(
                builder: (context) => LoginScreen(extraData: response.message),
              ));

             // route.pushToStart(context, LoginScreen.routeName);

            }else{
              route.pushMaterialRoute(context, VerificationCodeScreen.routeName  ,MaterialPageRoute(
                builder: (context) => VerificationCodeScreen(extraData: response.message,newUser: true,),
              ));
              //route.push(context,VerificationCodeScreen.routeName);
              //openDialog( response.message);
              //DialoguesUtils.showMessageDialogue(context: context,message: response.message);
            }

            //  navigateUser(response);
          }
        },
          onError: (exception) {
            _waits(false);
            openDialog(exception.toString());
            //CommonMethods.manageError(context, exception);
          },
        );

        //DialoguesUtils.showProgressbar(context: context);
        _waits(true);

      } else {
        // No-Internet Case
        Fimber.d("isNetwork Not Available");
        DialoguesUtils.noInternet(context);
      }
    });
  }






  _pressLoginButton(){
    print("User press \"Forgot password\" button");
    route.push(context, LoginScreen.routeName);
  }
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  bool _wait = false;
  ScrollController _scrollController = ScrollController();

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
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
    super.initState();
  }

  _initiOS(){

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

              IAppBar(context: context, text: "", color: Colors.white),

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


        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 30,),

        Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: IButton3(
                color: theme.colorCompanion, text:AppConstants.str_send_otp, textStyle: theme.text14boldWhite,  // LOGIN
                pressButton: (){
                  _pressSendOtpButton();
                })),

        SizedBox(height: 25,),

       Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
              child: Text(AppConstants.str_otp_will_send_descr,                    // ""Don't have an account? Create",",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text12White
              ),
            ),
       /* InkWell(
            onTap: () {
              _pressLoginButton();
            }, // needed
            child:*/

        Container(
          padding: EdgeInsets.fromLTRB(windowWidth * 0.03, windowWidth * 0.02,
              windowWidth * 0.03, windowWidth * 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppConstants.str_if_you_are_registered_descr,
                style: theme.text12White,
              ),
              /*SizedBox(
                height: 4.0,
                width: 4.0,
              ),*/
              GestureDetector(
                onTap: () {
                  _pressLoginButton();
                  /*Navigator.pushNamed(
                        context, SignUpScreen.routeName);*/
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0),
                ),
              ),
            ],
          ),
        )

        /* Container(
              padding: EdgeInsets.fromLTRB(windowWidth *0.05,windowWidth *0.05, windowWidth *0.05,windowWidth *0.2) ,
              child: Text(AppConstants.str_if_you_are_registered_descr,                    // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text12boldWhite
              ),
            )*/
        /*)*/

      ],
    );
  }
}
