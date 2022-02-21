
import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/api_repository.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';


/// flutter pub run build_runner build
/// //flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
/// registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
//flutter clean
//flutter pub cache repair
//https://stackoverflow.com/questions/25122287/java-security-cert-certpathvalidatorexception-trust-anchor-for-certification-pa
//https://stackoverflow.com/questions/63309132/why-is-my-post-request-not-working-in-flutter-for-my-api-only

class CommonMethods {

  static Dio dio;
  static BaseOptions _baseOptions;

  /// Get api repository instance
  /// Get api repository instance
  static ApiRepository getApiRepository() {
    return ApiRepository.instance;
  }

  /// Get dio instance
  Dio getDio(String url) {
    Fimber.d(
        "PREF_TOKEN 1 : ${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}");

    //'Content-type': 'application/x-www-form-urlencoded',
    _baseOptions = new BaseOptions(
        baseUrl: url,
        receiveDataWhenStatusError: true,
        connectTimeout: 60000,
        receiveTimeout: 60000,
        headers: ({
          'Content-type': 'application/x-www-form-urlencoded',
          /*'Content-type': 'application/json; charset=utf-8'*/
        }));
    dio = new Dio(_baseOptions);
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options,handler) async {
      /// Do something before request is sent
      return handler.next(options);
      //return options; //continue
      /// If you want to resolve the request with some custom data，
      /// you can return a `Response` object or return `dio.resolve(data)`.
      /// If you want to reject the request with a error message,
      /// you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: ( response,handler) async {
      /// Do something with response data
      return handler.next(response); // continue
    }, onError: (DioError dioError,handler) async {
      /// Do something with response error
      /*if (dioError.type == DioErrorType.RESPONSE) {
        final ErrorResponse errorResponse =
        ErrorResponse.fromJson(dioError.response.data);
        return errorResponse; //continue
      } else {*/
        return handler.next(dioError);
      /*}*/
    }));
    /*}*/

    //Below code use to repvent server cetificates issue
    /*if (Platform.isAndroid) {

      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

    }*/

    return dio;
  }

  /// Remove single header
  static removeHeader(String headerName) {
    if (dio.options.headers.containsKey(headerName)) {
      dio.options.headers.remove(headerName);
    }else{
      throw "Header not available";
    }
  }

  /// Add single header
  static addHeaders(var customHeaders) {
    if (dio == null) {
      throw "dio not initialized";
    } else {
      dio.options.headers.addAll(customHeaders);
    }
  }

  /// This is common method used to manage api/service error for entire application
  static void manageError(BuildContext context, var exception) {
    if (exception?.message != null &&
        exception?.message?.error != null /*&&
        exception?.message?.error is ErrorResponse*/) {
      Fimber.d("Failed ${exception.message}");
      Fimber.d("${exception.message}");
      String error = exception.message.error.message;
      if (error.isNotEmpty) {
        if (error.toLowerCase().contains("session expired")) {
          Fimber.d("session expired called");

          DialoguesUtils.hideProgressbar(context);

          showDialog(
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text("Information"),
              content: new Text(error.toString() ?? ""),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                      AppConstants.str_ok),
                  onPressed: () {

                    Navigator.of(context)
                        .pushReplacementNamed("/login");
                    //PreferenceHelper.clear();
                  },
                )
              ],
            ),
          );
        } else {
          DialoguesUtils.hideProgressbar(context);

          showDialog(
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(AppConstants.str_information),
              content: new Text(error.toString() ?? ""),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(AppConstants.str_ok),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
      } else {
        DialoguesUtils.hideProgressbar(context);
        showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
                AppConstants.str_information),
            content: new Text(
                AppConstants.msgErrorOrNull),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child:
                new Text(AppConstants.str_ok),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
    } else {
      DialoguesUtils.hideProgressbar(context);
      showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
              AppConstants.str_information),
          content: new Text(AppConstants.msgErrorOrNull),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(AppConstants.str_ok),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }
}


