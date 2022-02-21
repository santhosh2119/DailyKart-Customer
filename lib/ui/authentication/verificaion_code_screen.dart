import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/request/VerifyOtpRequest.dart';
import 'package:fooddelivery/data/services/response/verify_otp_response.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/verify_otp_of_forgot_password.dart';
import 'package:fooddelivery/model/server/verify_otp_of_new_user.dart';
import 'package:fooddelivery/ui/authentication/location_details_screen.dart';
import 'package:fooddelivery/ui/authentication/update_password_screen.dart';
import 'package:fooddelivery/ui/main/Delivery/payments.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iVerifySMS.dart';
import 'package:fooddelivery/widget/iappBar.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';

class VerificationCodeScreen extends StatefulWidget {
  static  const String routeName="/verification";
  final String extraData;
  final bool newUser;
  const VerificationCodeScreen({Key key,this.extraData,this.newUser=false}) : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  var windowWidth;
  var windowHeight;
  ScrollController _scrollController = ScrollController();
  final editControllerPhone = TextEditingController();
  Widget _dialogBody = Container();
  bool _wait = false;
  double _show = 0;

  @override
  void initState() {
    super.initState();
    Fimber.d("extraData : ${widget.extraData}");
    Future.delayed(const Duration(milliseconds: 1000), () {
      openDialog(widget.extraData);
      //_initCameraPosition();
    });

  }

  @override
  Widget build(BuildContext context) {
    /*double _show = 0;*/
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    /*Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });*/
    return Scaffold(
            backgroundColor: theme.colorBackground,

            body: Directionality(
              textDirection: strings.direction,
              child: Stack(
                children: <Widget>[

                  IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: windowWidth,
                      child: ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        children: _body(),
                      )),

                  if (_wait)
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
                    ),

                  IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
                    body: _dialogBody, backgroundColor: theme.colorBackground,),

                  IAppBar(context: context, text: "", color: Colors.white),



                ],
              ),
            )/*)*/);
  }

  _body(){
    var list = List<Widget>();

    list.add(Container(
      width: windowWidth*0.4,
      height: windowWidth*0.4,
      child: Image.asset("assets/logo.png", fit: BoxFit.contain),
    ));

    list.add(SizedBox(height: windowHeight*0.05,));

    /*if (step == 1){
      list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text(strings.get(30),                        // "Verify phone number"
          style: theme.text20boldWhite, textAlign: TextAlign.start,
        ),
      ));
      list.add(SizedBox(height: 15,));
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 0.5,
        color: Colors.white.withAlpha(200),
      ));
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child:
          IInputField2a(
              hint: strings.get(28),            // Phone number
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              controller: editControllerPhone,
              type: TextInputType.phone
          )
      ));
      list.add(SizedBox(height: 5,));
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 0.5,
        color: Colors.white.withAlpha(200),               // line
      ));

      list.add(SizedBox(height: 20,));
      list.add(Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: IButton3(
              color: theme.colorCompanion, text: strings.get(29), textStyle: theme.text14boldWhite,  // CONTINUE
              pressButton: (){
                _pressCreateAccountButton();
              })));
    }*/
    /*if (step == 2){*/
      list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text("${strings.get(288)} ${editControllerPhone.text} ${strings.get(289)}",   // On phone number send SMS with code. Enter code
          style: theme.text20boldWhite, textAlign: TextAlign.start,
        ),
      ));
      list.add(SizedBox(height: 15,));
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: IVerifySMS(color: Colors.white,
            callback: _onCodeChange),
      ),);
    /*}*/
    list.add(SizedBox(height: 30,));

    return list;
  }

  _pressResendOtp(){
    openDialog("Resend otp called");
  }
  _onCodeChange(String code){
    Fimber.d("code : $code codeLength : ${code.length}");
    if (code.length == 4){
      Fimber.d("code.length == 6 called");
      //route.pushToStart(context, "/login");
      FocusScope.of(context).unfocus();

      //_validateOtp(code);
      if(PreferenceHelper.getInt(AppConstants.PREF_STEPS_COMPLETED) >1 ){
        _validateForgotPasswordOtpNew(code);
      }else{
        _validateOtpNew(code);
      }


    }else{
      //openDialog("Please enter valid verification code");
    }

  }

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
        InkWell(
            onTap: () {
              _pressResendOtp();
            }, // needed
            child:Container(
              padding: EdgeInsets.fromLTRB(windowWidth *0.05,windowWidth *0.05, windowWidth *0.05,windowWidth *0.2) ,
              child: Text(AppConstants.str_if_you_are_registered_descr,                    // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text12boldWhite
              ),
            ))
      ],
    );

    setState(() {
      _show = 1;
    });
  }

  _success(VerifyOtpResponse response) {
    _waits(false);
    //openDialog( response);
  /*  final VerifyOtpResponse res =
    VerifyOtpResponse.fromJson(response);*/
    if (response != null) {

      if(response.status == true){
        PreferenceHelper.setString(AppConstants.PREF_USER_ID, response.userid);
        PreferenceHelper.setInt(AppConstants.PREF_STEPS_COMPLETED, response.stepsCompleted);
        //PreferenceHelper.setString(AppConstants.PREF_PASSWORD, password);
        if(PreferenceHelper.getInt(AppConstants.PREF_STEPS_COMPLETED) == 4 ){
          route.push(context, UpdatePasswordScreen.routeName);

        }else{
          route.push(context, LocationDetailsScreen.routeName);
        }

      }else{
        openDialog( response.message);
        // DialoguesUtils.showMessageDialogue(context: context,message: response.message);
      }

      //  navigateUser(response);
    }
  }
  _onError(String message){
    _waits(false);
    openDialog(message);
    //CommonMethods.manageError(context, message);
  }

  _validateOtpNew(String otpValue) {
    NetworkUtils
        .isNetwork()
        .then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");


        //  otp: otpValue,
        //mobile: PreferenceHelper.getString(AppConstants.PREF_MOBILE),

        _waits(true);
        verifyOtpOfNewUser(PreferenceHelper.getString(AppConstants.PREF_MOBILE), otpValue,_success,_onError);

      } else {
        // No-Internet Case
        Fimber.d("isNetwork Not Available");
        DialoguesUtils.noInternet(context);
      }
    });
  }


  _validateForgotPasswordOtpNew(String otpValue) {
    NetworkUtils
        .isNetwork()
        .then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");


      //  otp: otpValue,
      //mobile: PreferenceHelper.getString(AppConstants.PREF_MOBILE),

        _waits(true);
        verifyOtpOfForgotPassword(PreferenceHelper.getString(AppConstants.PREF_MOBILE), otpValue,_success,_onError);

      } else {
        // No-Internet Case
        Fimber.d("isNetwork Not Available");
        DialoguesUtils.noInternet(context);
      }
    });
  }




  //This will need to when we got error
  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    //route.disposeLast();
    editControllerPhone.dispose();
    super.dispose();
  }
}
