
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:sweetalert/sweetalert.dart';


//import 'package:fooddelivery/sweetalert/sweetalert.dart';
//import 'package:fooddelivery/utils/AppLocalizations.dart';

/// Common utilities manage dialogues
class DialoguesUtils{
  /// Hide progressbar
  static hideProgressbar(BuildContext context) {
    Navigator.pop(context);
  }

  /// Show progress bar
  static void showProgressbar({BuildContext context,String message="Please wait..."}) {
    SweetAlert.show(context,
        subtitle: message, style: SweetAlertStyle.loading);
  }

  /// Show no internet dialogue
  /// Show no internet dialogue
  static void noInternet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        content: new Text(AppConstants.msgNoInternet),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true, child: new Text(AppConstants.str_ok),onPressed: (){
            Navigator.pop(context);
          },
          )
        ],
      ),
    );


  }

  /// Show common message dialogue
  static void showMessageDialogue({BuildContext context,String message="Please wait...",bool dismissDialog = true}) {

    try {
      if(dismissDialog == true) {
        hideProgressbar(context);
      }

    } catch (e) {
      Fimber.d("Error in hideProgressbar");
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(AppConstants.str_information),
        content: new Text(message.toString() ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true, child: new Text(AppConstants.str_ok),onPressed: (){
            Navigator.pop(context);
          },
          )
        ],
      ),
    );

  }


}