import 'package:fimber/fimber.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/response/favourite_data_response.dart';
import 'package:fooddelivery/data/services/response/home_screen_response.dart';
import 'package:fooddelivery/data/services/response/location_response.dart';
import 'package:fooddelivery/data/services/response/login_response.dart';
import 'package:fooddelivery/data/services/response/common_response.dart';
import 'package:fooddelivery/data/services/response/notifications_data_response.dart';
import 'package:fooddelivery/data/services/response/rewards_response.dart';
import 'package:fooddelivery/data/services/response/validate_mobile_no_response.dart';
import 'package:fooddelivery/data/services/response/verify_otp_response.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:dio/dio.dart';

class ApiRepository {

  static CommonMethods mCommonMethods = new CommonMethods();

  static Dio dio = mCommonMethods.getDio("${AppConstants.BASEURL}");



  static final ApiRepository _singleton = new ApiRepository._internal();
  ApiRepository._internal();
  static ApiRepository get instance => _singleton;


  /// Get login details
  Future<LoginResponse> getLoginDetails(var loginRequestData) async {
    Fimber.d('getLoginDetails called');

    try {
      Response response =
      await dio.post("/login", data: loginRequestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final LoginResponse loginResponse =
        LoginResponse.fromJson(response.data);
        if(loginResponse.status){
          PreferenceHelper.setString(
              AppConstants.PREF_USER_ID, loginResponse.userid);
          PreferenceHelper.setString(
              AppConstants.PREF_LOGIN_TYPE, loginResponse.logintype);
          PreferenceHelper.setInt(
              AppConstants.PREF_STEPS_COMPLETED, int.parse(loginResponse.stepsCompleted));
        }

        return loginResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }
  }


   // This service use to validate otp during forgot password flow
  Future<VerifyOtpResponse> validateOtp(var requestData) async {
    Fimber.d('validateOtp called');

    try {
      CommonMethods.removeHeader("Content-Type");
      CommonMethods.addHeaders({
        /*'Content-type': 'application/json',*/
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': "application/json",
      });
    } catch (e) {
      print(e);
      Fimber.d("Error in adding headers");
    }

      try {
      Response responseData =
      await dio.post("/check_forgototp", data: requestData);
      if (responseData.data.toString().isEmpty) {
        throw Exception();
      } else {
        final VerifyOtpResponse verifyOtpResponse =
        VerifyOtpResponse.fromJson(responseData.data);
        if(verifyOtpResponse.status){
          PreferenceHelper.setString(
              AppConstants.PREF_USER_ID, verifyOtpResponse.userid);
          PreferenceHelper.setInt(
              AppConstants.PREF_STEPS_COMPLETED, verifyOtpResponse.stepsCompleted);
        }

        return verifyOtpResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }
  }

  //This service used to update user password
  Future<CommonResponse> updatePassword(var requestData) async {
    Fimber.d('updatePassword called');

    try {
      Response responseData =
      await dio.post("/passwordupdate", data: requestData);
      if (responseData.data.toString().isEmpty) {
        throw Exception();
      } else {
        final CommonResponse response =
        CommonResponse.fromJson(responseData.data);
        return response;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }
  }


  //This servie use to check weather mobile no already register ot new no
  Future<ValidateMobileNoResponse> validateMobileNo(var loginRequestData) async {
    Fimber.d('getLoginDetails called');

    try {
      Response res =
      await dio.post("/step1", data: loginRequestData);
      if (res.data.toString().isEmpty) {
        throw Exception();
      } else {
        var steps_completed =res.data["steps_completed"];
        if(steps_completed is int){
          final ValidateMobileNoResponse response =
          ValidateMobileNoResponse.fromJson(res.data);
          return response;
        }else{
          final ValidateMobileNoResponse response = ValidateMobileNoResponse(
            status: res.data["status"],
            message: res.data["message"],
            isRegistered: res.data["isRegistered"],
            stepsCompleted: int.parse(steps_completed),

          );
          return response;
        }

      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }
  }

  //This method use to register new user
  Future<bool> updateUserProfile(var requestData) async {
    Fimber.d('updateUserProfile called');

    try {
      Response responseData =
      await dio.post("/personaldataupdate", data: requestData);
      if (responseData.data.toString().isEmpty) {
        throw Exception();
      } else {
        var steps_completed =responseData.data["steps_completed"];
        PreferenceHelper.setInt(AppConstants.PREF_STEPS_COMPLETED,steps_completed);

        /*final LoginResponse response =
        LoginResponse.fromJson(responseData.data);*/
        return responseData.data["status"];
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }
  }
  /**
   * This method get home screen related all info
   */
  Future<FavouriteDataResponse> getFavouriteItemData(var requestData)async{
    Fimber.d('getFavouriteItemData called');

    try {
      Response response =
      await dio.post("/wishlist", data: requestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final FavouriteDataResponse homeScreenResponse =
        FavouriteDataResponse.fromJson(response.data);
        return homeScreenResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }

  }

  /**
   * This method get home screen related all info
   */
  Future<NotificationsDataResponse> getNotificationsData(var requestData)async{
    Fimber.d('getNotificationsData called');

    try {
      Response response =
      await dio.post("/userNotifications", data: requestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final NotificationsDataResponse notificationsDataResponse =
        NotificationsDataResponse.fromJson(response.data);
        return notificationsDataResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }

  }

  Future<CommonResponse> removeFromFavouriteItems(var requestData)async{
    Fimber.d('removeFromFavouriteItems called');

    try {
      Response response =
      await dio.post("/removewishlist", data: requestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final CommonResponse commonResponse =
        CommonResponse.fromJson(response.data);
        return commonResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }

  }

  Future<CommonResponse> addItemToFavourite(var requestData)async{
    Fimber.d('addItemToFavourite called');

    try {
      Response response =
      await dio.post("/addtowishlist", data: requestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final CommonResponse commonResponse =
        CommonResponse.fromJson(response.data);
        return commonResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }

  }

  /**
   * This method get home screen related all info
   */
  Future<HomeScreenResponse> getHomeScreenDetails(var requestData)async{
    Fimber.d('getHomeScreenDetails called');

    try {
      Response response =
          await dio.post("/home", data: requestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final HomeScreenResponse homeScreenResponse =
        HomeScreenResponse.fromJson(response.data);
        return homeScreenResponse;
      }
    } on DioError catch (dioError) {
      Fimber.d("Service error : $dioError");
      throw Exception(dioError);
    }



  }

  /**
   * This method get rewards related info
   */
  Future<RewardsResponse> getUserRewardsDetails(var requestData)async{
    Fimber.d('getUserRewardsDetails called');

    try {
      Response response =
      await dio.post("/userdata", data: requestData);
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final RewardsResponse rewardsResponse =
        RewardsResponse.fromJson(response.data);
        return rewardsResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }

  }

  Future<LocationResponse> getLocationDetails() async {
    Fimber.d('getLoginDetails called');

    try {
      Response response =
      await dio.get("/shreejalocations");
      if (response.data.toString().isEmpty) {
        throw Exception();
      } else {
        final LocationResponse locationResponse =
        LocationResponse.fromJson(response.data);
        return locationResponse;
      }
    } on DioError catch (dioError) {
      throw Exception(dioError);
    }
  }







}