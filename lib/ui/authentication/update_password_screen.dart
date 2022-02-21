import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/request/update_password_request.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/ui/login/login_screen.dart';
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

class UpdatePasswordScreen extends StatefulWidget {
  static  const String routeName="/updatePassword";
  const UpdatePasswordScreen({Key key}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {

  var windowWidth;
  var windowHeight;

  final editControllerPassword = TextEditingController();
  final editControllerConfirmPassword = TextEditingController();
  double _show = 0;
  Widget _dialogBody = Container();

  bool _wait = false;


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
          child: Text( AppConstants.str_update_password,                        // "Forgot password"
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
            IInputField2PasswordA(
              maxLength: 20,
              hint: AppConstants.str_enter_new_password,
              icon: Icons.password,
              colorDefaultText: Colors.white,
              controller: editControllerPassword,

            )
        ),

        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2PasswordA(
              maxLength: 20,
              hint: AppConstants.str_enter_confirm_password,
              icon: Icons.password_sharp,
              colorDefaultText: Colors.white,
              controller: editControllerConfirmPassword,

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
                color: theme.colorCompanion, text: AppConstants.str_update, textStyle: theme.text14boldWhite,  // SEND
                pressButton: (){
                  _pressSendButton();
                })),

        SizedBox(height: 25,),
      ],

    );
  }



  //validate password and confirm password
  _pressSendButton(){
    print("User pressed \"UPDATE\" button");
    print("Password: ${editControllerPassword.text}");
    print("Confirm Password: ${editControllerConfirmPassword.text}");
    if (editControllerPassword.text.isEmpty) {
      return openDialog(
          AppConstants.str_please_enter_password);
    }else if (editControllerPassword.text.isEmpty){
      return openDialog(AppConstants.str_please_enter_confirm_password);
    }else if(editControllerPassword.text!=editControllerConfirmPassword.text){
      return openDialog(AppConstants.str_confirm_password_mismatch);
    }



    _udpatePassword();

    //updatePassword(editControllerMobile.text, _success, _error) ;

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

  _udpatePassword(){
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        UpdatePasswordRequest updatePasswordRequest = new UpdatePasswordRequest(
          password: editControllerPassword.text,
          userid: PreferenceHelper.getString(AppConstants.PREF_USER_ID),
        );
        //  var requestBody = jsonEncode(loginRequest);
        // Fimber.d("Request Data : $requestBody");
        // var dataa = FormData.fromMap(loginRequest);
        CommonMethods.getApiRepository().updatePassword(updatePasswordRequest.toMap()).then((response) {
          Fimber.d("updatePassword Success");
          _waits(false);
          //_popDialog();
          //DialoguesUtils.hideProgressbar(context);
          if (response != null) {
            if(response.status == true){
              //PreferenceHelper.setString(AppConstants.PREF_PASSWORD, password);
              //TODO : Here need to show message to user
              route.pushToStart(context, LoginScreen.routeName);
              //openDialog( response.message);
            }else{
              openDialog( response.message);
              //route.push(context, UpdatePasswordScreen.routeName);
              // DialoguesUtils.showMessageDialogue(context: context,message: response.message);
            }

            //  navigateUser(response);
          }
        },
          onError: (exception) {
            _waits(false);
            CommonMethods.manageError(context, exception);
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
  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }


  _success(String error){
    _waits(false);
    openDialog(error); // "A letter with a new password has been sent to the specified E-mail",


    //PreferenceHelper.setString(AppConstants.PREF_MOBILE, editControllerMobile.text);
    route.push(context,  LoginScreen.routeName);

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
  void dispose() {
    route.disposeLast();
    editControllerPassword.dispose();
    editControllerConfirmPassword.dispose();
    super.dispose();
  }
}
