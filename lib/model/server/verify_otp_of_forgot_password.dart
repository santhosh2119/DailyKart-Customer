import 'package:fooddelivery/data/services/response/verify_otp_response.dart';
import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

verifyOtpOfForgotPassword(String mobile,String otp, Function(VerifyOtpResponse) callback, Function(String) callbackError) async {
  try {

    var url = "${serverPath}check_forgototp";
    /*var body = json.encoder.convert(
        {
          'mobile': '$mobile'
        }
    );*/
    var body =
        {
          'mobile': '$mobile',
          'otp':'$otp'
        };
    var response = await http.post(Uri.parse(url), headers: {
      /*'Content-type': 'application/json; charset=utf-8',*/
      /*'Content-type': 'application/json; charset=utf-8',*/
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': "application/json",
    },body:  body).timeout(const Duration(seconds: 30));



    dprint('$url');
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    var jsonResult = json.decode(response.body);
    if (response.statusCode == 500)
      return callbackError(jsonResult["message"].toString());

    if (response.statusCode == 200) {
      if (jsonResult["status"] == true){
        final VerifyOtpResponse verifyOtpResponse =
        VerifyOtpResponse.fromJson(jsonResult);
        callback(verifyOtpResponse);
      }
      else{

        callbackError(jsonResult["message"]);
      }
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

