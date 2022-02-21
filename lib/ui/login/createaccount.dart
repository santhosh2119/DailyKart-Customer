import 'dart:io';

//import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/request/ProfileDataRequest.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/model/server/register.dart';
import 'package:fooddelivery/model/utils.dart';
import 'package:fooddelivery/ui/authentication/web_view_component.dart';
import 'package:fooddelivery/ui/main/home/home.dart';
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

import 'otp.dart';

class CreateAccountScreen extends StatefulWidget {
  static const String routeName = "/createaccount";

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressCreateAccountButton() {
    print("User pressed \"CREATE ACCOUNT\" button");
    print(
        "Login: ${editControllerFullName.text}, E-mail: ${editControllerEmail.text}, "
        "password1: ${editControllerPassword.text}, password2: ${editControllerReferralCode.text}");

    if (editControllerFullName.text.isEmpty)
      return openDialog("Please enter full name"); // "Enter your Login"
    if (editControllerHouseNo.text.isEmpty)
      return openDialog("Please enter house name"); // "Enter your Login"
    if (editControllerStreet.text.isEmpty)
      return openDialog("Please enter street name"); // "Enter your Login"
    if (editControllerEmail.text.isNotEmpty) {
      if (!validateEmail(editControllerEmail.text))
        return openDialog(strings.get(178)); // "You E-mail is incorrect"
    }
    if (editControllerCurrentLocation.text.isEmpty)
      return openDialog(
          "Please enter location details"); // "Enter your password"

    if (editControllerPassword.text.isEmpty)
      return openDialog("Please enter password"); // "Enter your password"

    if(checkedValue == false){
      return openDialog("Please check Terms & Conditions etc...");
    }

    /*if (appSettings.otp == "true")
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
              name: editControllerFullName.text,
              email: editControllerEmail.text,
              type: "email",
              password: editControllerPassword.text,
              photo: ""),
        ),
      );*/

    _waits(true);
    ProfileDataRequest profileDataRequest = new ProfileDataRequest(
      name: editControllerFullName.text.trim(),
      alt_number: "",
      email: editControllerEmail.text.trim(),
      city: "0",
      area: PreferenceHelper.getString(AppConstants.PREF_LOCATION_ID),
      locality: editControllerStreet.text.trim(),
      address:
          "${editControllerStreet.text.trim()} , ${editControllerHouseNo.text.trim()} , ${editControllerLandMark.text.trim()} , ${editControllerCurrentLocation.text.trim()}",
      gps_loc: editControllerCurrentLocation.text.trim(),
      userid: PreferenceHelper.getString(AppConstants.PREF_USER_ID),
      password: editControllerPassword.text.trim(),
      refid: editControllerReferralCode.text.trim(),
      house_no: editControllerHouseNo.text.trim(),
      landmark: editControllerLandMark.text.trim(),
      areanotlisted: "",
      latlong: "",
      firebaseToken:  PreferenceHelper.getString(AppConstants.PREF_FCM_TOKEN),
    );
    /*register(editControllerEmail.text, editControllerPassword.text,
        editControllerFullName.text, "email", "", _okUserEnter, _error);*/
    _udpateProfile(profileDataRequest);
  }

  _udpateProfile(ProfileDataRequest profileDataRequest) {
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        //  var requestBody = jsonEncode(loginRequest);
        // Fimber.d("Request Data : $requestBody");
        // var dataa = FormData.fromMap(loginRequest);
        CommonMethods.getApiRepository()
            .updateUserProfile(profileDataRequest.toMap())
            .then(
          (response) {
            Fimber.d("updateUserProfile Success");
            _waits(false);
            //_popDialog();
            //DialoguesUtils.hideProgressbar(context);
            if (response != null) {
              if (response == true) {
                // PreferenceHelper.setInt(AppConstants.PREF_STEPS_COMPLETED,response.stepsCompleted);
                //TODO : Here need to show message to user
                route.pushToStart(context, "/main");
                //openDialog( response.message);
              } else {
                openDialog("personal data update failed");
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

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerFullName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPassword = TextEditingController();
  final editControllerHouseNo = TextEditingController();
  final editControllerStreet = TextEditingController();
  final editControllerLandMark = TextEditingController();
  final editControllerCurrentLocation = TextEditingController();
  final editControllerReferralCode = TextEditingController();

  ScrollController _scrollController = ScrollController();
  bool checkedValue = false;

  _initiOS() {
    if (Platform.isIOS) {
      /* AppleSignIn.onCredentialRevoked.listen((_) {
        dprint("Credentials revoked");
      });*/
    }
  }

  _okUserEnter(String name, String password, String avatar, String email,
      String token, String typeReg) {
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, "", 0, typeReg);
    route.pushToStart(context, "/main");
  }

  bool _wait = false;

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }

  _error(String error) {
    _waits(false);
    if (error == "login_canceled") return;
    if (error == "3") return openDialog(strings.get(272)); // This email is busy
    openDialog("${strings.get(128)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    _initiOS();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    route.disposeLast();
    editControllerFullName.dispose();
    editControllerEmail.dispose();
    editControllerPassword.dispose();
    editControllerHouseNo.dispose();
    editControllerStreet.dispose();
    editControllerLandMark.dispose();
    editControllerCurrentLocation.dispose();
    editControllerReferralCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
    return WillPopScope(
        onWillPop: () async {
          if (_show != 0) {
            setState(() {
              _show = 0;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
            backgroundColor: theme.colorBackground,
            body: Directionality(
              textDirection: strings.direction,
              child: Stack(
                children: <Widget>[
                  IBackground4(
                      width: windowWidth, colorsGradient: theme.colorsGradient),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: windowWidth,
                    child: _body(),
                  ),
                  if (_wait)
                    (Container(
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
                    ))
                  else
                    (Container()),
                  IEasyDialog2(
                    setPosition: (double value) {
                      _show = value;
                    },
                    getPosition: () {
                      return _show;
                    },
                    color: theme.colorGrey,
                    body: _dialogBody,
                    backgroundColor: theme.colorBackground,
                  ),
                  IAppBar(context: context, text: "", color: Colors.white),
                ],
              ),
            )));
  }

  _body() {
    return ListView(
      shrinkWrap: false,
      controller: _scrollController,
      children: <Widget>[
        /* Container(
          width: windowWidth*0.4,
          height: windowWidth*0.4,
          child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),*/

        SizedBox(
          height: windowHeight * 0.05,
        ),

        Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(
            strings.get(24), // "Create an Account!"
            style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ),

        SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //Full name
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_full_name,
              // "Full name"
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              controller: editControllerFullName,
              type: TextInputType.name,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //Email id
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_email_id,
              // "E-mail address",
              icon: Icons.alternate_email,
              type: TextInputType.emailAddress,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //House no
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_house_no,
              // "House No",
              icon: Icons.house_sharp,
              type: TextInputType.text,
              colorDefaultText: Colors.white,
              controller: editControllerHouseNo,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //Street
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_street,
              // "Street",
              icon: Icons.house_sharp,
              type: TextInputType.text,
              colorDefaultText: Colors.white,
              controller: editControllerStreet,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //Landmark
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_land_mark,
              // "Landmark",
              icon: Icons.house_sharp,
              type: TextInputType.text,
              colorDefaultText: Colors.white,
              controller: editControllerLandMark,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //Current Location
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_current_location,
              // "Current Location",
              icon: Icons.location_on,
              type: TextInputType.text,
              colorDefaultText: Colors.white,
              controller: editControllerCurrentLocation,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        //Password
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2PasswordA(
              hint: AppConstants.str_enter_password, // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              controller: editControllerPassword,
            )),

        SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2a(
              hint: AppConstants.str_referral_code,
              // "Landmark",
              icon: Icons.account_tree,
              type: TextInputType.text,
              colorDefaultText: Colors.white,
              controller: editControllerReferralCode,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200), // line
        ),

        SizedBox(
          height: 20,
        ),

        Container(
            /*color: Colors.black,*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  value: this.checkedValue,
                  onChanged: (bool value) {
                    setState(() {
                      this.checkedValue = value;
                    });
                  },
                ),
                Text(
                  AppConstants.str_i_have_read_descr,
                  style: theme.text12White,
                ),
                /*SizedBox(
                height: 4.0,
                width: 4.0,
              ),*/
                GestureDetector(
                  onTap: () {

                  _openUrl('https://drive.google.com/file/d/1K78Ziq60vs1llDtMrDi0YCsaQbsjFhVd/view');

                   /* void _openLinkInGoogleChrome() {
                      final AndroidIntent intent = AndroidIntent(
                          action: 'action_view',
                          data: Uri.encodeFull('https://flutter.io'),
                          package: 'com.android.chrome');
                      intent.launch();
                    }
*/
                    /*Navigator.of(context).pushNamed(
                        WebViewComponent.routeName,
                        arguments: "https://drive.google.com/file/d/1K78Ziq60vs1llDtMrDi0YCsaQbsjFhVd/view");*/

                    /*Navigator.pushNamed(
                        context, SignUpScreen.routeName);*/
                  },
                  child: Text(
                    AppConstants.str_terms_and_conditions, //Terms & Conditions
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ),
              ],
            )),

        Container(
            /*color: Colors.red,*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(windowWidth * 0.12, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      /*Navigator.pushNamed(
                        context, SignUpScreen.routeName);*/
                      _openUrl('https://drive.google.com/file/d/1K78Ziq60vs1llDtMrDi0YCsaQbsjFhVd/view');

                    },
                    child: Text(
                      AppConstants.str_return_policy,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                  ),
                ),
                Text(
                  " and ",
                  style: theme.text12White,
                ),
                GestureDetector(
                  onTap: () {
                    /*Navigator.pushNamed(
                        context, SignUpScreen.routeName);*/
                    _openUrl('https://drive.google.com/file/d/1K78Ziq60vs1llDtMrDi0YCsaQbsjFhVd/view');
                  },
                  child: Text(
                    AppConstants.str_privacy_policy,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  ),
                ),
              ],
            )),

        SizedBox(
          height: 20,
        ),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: IButton3(
                color: theme.colorCompanion,
                text: strings.get(26),
                textStyle: theme.text14boldWhite,
                // CREATE ACCOUNT
                pressButton: () {
                  _pressCreateAccountButton();
                })),

        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void _openUrl(String url) {
    final AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull(
          url),
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  _login(String type, String id, String name, String photo) {
    dprint("Reg: type=$type, id=$id, name=$name, photo=$photo");
    if (appSettings.otp == "true")
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
              name: name,
              email: "$id@$type.com",
              type: type,
              password: id,
              photo: photo),
        ),
      );

    register("$id@$type.com", id, name, type, photo, _okUserEnter, _error);
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
    _dialogBody = Column(
      children: [
        Text(
          _text,
          style: theme.text14,
        ),
        SizedBox(
          height: 40,
        ),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155), // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );

    setState(() {
      _show = 1;
    });
  }
}
