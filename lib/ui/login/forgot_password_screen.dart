import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/forgot.dart';
import 'package:fooddelivery/ui/authentication/verificaion_code_screen.dart';
import 'package:fooddelivery/ui/login/otp.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iappBar.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';
import 'package:fooddelivery/widget/iinputField2a.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressSendButton(){
    print("User pressed \"SEND\" button");
    print("E-mail: ${editControllerMobile.text}");
    if (editControllerMobile.text.isEmpty)
      return openDialog(AppConstants.str_please_enter_mobile_no); // "Enter your E-mail"
    /*if (!_validateEmail(editControllerEmail.text))
      return openDialog(strings.get(178)); // "You E-mail is incorrect"*/
    if(editControllerMobile.text.length !=10){
      return openDialog(AppConstants.str_please_enter_valid_mobile_no); // "Enter your E-mail"
    }

    _waits(true);
    //TODO: temporary commented for testing
    forgotPassword(editControllerMobile.text, _success, _error) ;

    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(
            name: "name",
            email: "sa@gmail.com",
            type: "type",
            password: "id",
            photo: "photo"
        ),
      ),
    );*/

    //route.pushToStart(context, VerificationCodeScreen.routeName);
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerMobile = TextEditingController();
  bool _wait = false;

  _error(String error){
    _waits(false);
    if (error == "5000")
      return openDialog(strings.get(136)); //  "User with this Email was not found!",
    if (error == "5001")
      return openDialog(strings.get(137)); //  "Failed to send Email. Please try again later.",
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _success(String error){
    _waits(false);
    //openDialog(error); // "A letter with a new password has been sent to the specified E-mail",


    PreferenceHelper.setString(AppConstants.PREF_MOBILE, editControllerMobile.text);

    route.pushMaterialRoute(context, VerificationCodeScreen.routeName  ,MaterialPageRoute(
      builder: (context) => VerificationCodeScreen(extraData:error,newUser: false,),
    ));

    //route.push(context,  VerificationCodeScreen.routeName);

    //route.pushToStart(context, VerificationCodeScreen.routeName);

   /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(
            name: "name",
            email: "sa@gmail.com",
            type: "type",
            password: "id",
            photo: "photo"
        ),
      )
    );*/
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerMobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

           IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

           IAppBar(context: context, text: "", color: Colors.white),

           Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  width: windowWidth,
                  child: _body(),
                  )
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

        ],
      ),
    ));
  }

  _body(){
    return Column(
      children: <Widget>[

        Expanded(
            child: Container(
              width: windowWidth*0.4,
              height: windowWidth*0.4,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain),
            )
        ),

        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Text(strings.get(20),                        // "Forgot password"
              style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 20,),

        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2a(
              maxLength: 10,
              hint: AppConstants.str_enter_mobile_no,            // "E-mail address"
              icon: Icons.mobile_friendly_sharp,
              colorDefaultText: Colors.white,
              controller: editControllerMobile,
                type: TextInputType.phone,

            )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 25,),

        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: IButton3(
                color: theme.colorCompanion, text: strings.get(23), textStyle: theme.text14boldWhite,  // SEND
                pressButton: (){
                  _pressSendButton();
                })),

        SizedBox(height: 25,),
      ],

    );
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
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

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }
}