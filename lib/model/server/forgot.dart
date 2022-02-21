import 'package:fooddelivery/model/dprint.dart';
import 'package:fooddelivery/config/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

forgotPassword(String mobile, Function(String) callback, Function(String) callbackError) async {
  try {

    var url = "${serverPath}passwordotp";
    /*var body = json.encoder.convert(
        {
          'mobile': '$mobile'
        }
    );*/
    var body =
        {
          'mobile': '$mobile'
        };
    var response = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': "application/json",
    },body:  body).timeout(const Duration(seconds: 30));



    dprint('$url');
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    var jsonResult = json.decode(response.body);
    if (response.statusCode == 500)
      return callbackError(jsonResult["message"].toString());

    if (response.statusCode == 200) {
      if (jsonResult["status"] == true)
        callback(jsonResult["message"]);
      else
        callbackError(jsonResult["error"]);
    }else
      callbackError("statusCode=${response.statusCode}");

  } catch (ex) {
    callbackError(ex.toString());
  }
}

