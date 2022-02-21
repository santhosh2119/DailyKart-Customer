import 'package:cached_network_image/cached_network_image.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppColors.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/response/location_response.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/ui/login/createaccount.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/easyDialog2.dart';
import 'package:fooddelivery/widget/iappBar.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:fooddelivery/widget/ibutton3.dart';

class LocationDetailsScreen extends StatefulWidget {
  static const String routeName = "/locationDetails";

  const LocationDetailsScreen({Key key}) : super(key: key);

  @override
  _LocationDetailsScreenState createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  bool _wait = false;
  double _show = 0;
  Widget _dialogBody = Container();
  List<LocationData> responseData = [];
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      _getLocationsData();
      // openDialog(widget.extraData);
      //_initCameraPosition();
    });

    //_getLocationsData();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
        backgroundColor: theme.colorBackground,

        body:Directionality(
            textDirection: strings.direction,
            child: Stack(
              children: <Widget>[

                IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

                /*Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  width: windowWidth,
                  child: Text("This is body")*//*Column(children: <Widget>[
              Expanded(
                child: new ListView.builder(
                    itemCount:
                    responseData?.length*//**//*== null ? 0 : responseData.length*//**//*,
                    itemBuilder: (BuildContext context, int index) {
                      Fimber.d("Image URL : ${responseData[index].image}");
                      final imageUrl = AppConstants.IMAGE_STAGE_BASE_URL +
                          responseData[index].image;
                      Fimber.d("Complete Image URL : $imageUrl");
                      return Column(
                        children: <Widget>[
                          Image.network(
                            "https://www.lifewire.com/thmb/8i_QSIuHkv2XgxW9qwHiB7FBJ7o=/1473x1105/smart/filters:no_upscale()/Maplocation_-5a492a4e482c52003601ea25.jpg",
                            width: 200,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            responseData[index].location,
                            style: theme.text16Companyon,
                          ),

                          *//**//*ListTile(

                            title: Text(
                              responseData[index].location,
                              style: theme.text12grey,
                            ),
                            leading: CircleAvatar(backgroundImage: AssetImage("assets/logo.png")),
                            onTap: () {
                              *//**//* *//**//*PreferenceHelper.setInt(AppConstants.PREF_SELECTED_SUB_CATEGORY_ID , searchList[index].requestSubCategoryId);
                    PreferenceHelper.setInt(AppConstants.PREF_SELECTED_CATEGORY_ID , searchList[index].requestCategoryId);*//**//* *//**//*
                              //Navigator.pushNamed(context, CreateRequestScreen.routeName,arguments: searchList[index].requestSubCategoryName??"");
                              Fimber.d(
                                  "User clicked on category : ${responseData[index].id}");
                            },
                          ),*//**//*
                          Divider(
                            height: 0.1,
                            color: AppColors.colorDivider,
                            thickness: 0.4,
                          ),
                        ],
                      );
                    }),
              )
            ])*//*,
                ),*/

            Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.fromLTRB(20, windowWidth*0.15, 20, 0),
                width: windowWidth,
              child: Column(children: <Widget>[
                Expanded(
                  child: new ListView.builder(
                      itemCount:
                      responseData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        Fimber.d("Image URL : ${responseData[index].image}");
                        final imageUrl = AppConstants.IMAGE_STAGE_BASE_URL +
                            responseData[index].image;
                        Fimber.d("Complete Image URL : $imageUrl");
                        return  GestureDetector(
                            onTap: (){
                          print("Clicked on ${responseData[index].id}");
                            PreferenceHelper.setString(AppConstants.PREF_LOCATION_ID, responseData[index].id);
                          route.push(context, CreateAccountScreen.routeName);
                        },
                        child: Column(
                          children: <Widget>[


                            CachedNetworkImage(
                              width: double.infinity,
                              height: windowHeight*0.2,
                              imageUrl: imageUrl,
                              placeholder: (context, url) => new CircularProgressIndicator(),
                              /*errorWidget: (context, url, error) => new Icon(Icons.error),*/
                              errorWidget: (context, url, error) => Image.network(
                                "https://www.lifewire.com/thmb/8i_QSIuHkv2XgxW9qwHiB7FBJ7o=/1473x1105/smart/filters:no_upscale()/Maplocation_-5a492a4e482c52003601ea25.jpg",
                                width: double.infinity,
                                height: windowHeight*0.2,

                                fit: BoxFit.cover,
                              ),
                            ),

                           /* Image.network(
                              "https://www.lifewire.com/thmb/8i_QSIuHkv2XgxW9qwHiB7FBJ7o=/1473x1105/smart/filters:no_upscale()/Maplocation_-5a492a4e482c52003601ea25.jpg",
                              width: double.infinity,
                              height: windowHeight*0.2,

                              fit: BoxFit.cover,
                            ),*/
                            Text(
                              responseData[index].location,
                              style: theme.text16boldWhite,
                            ),

                            Divider(
                              height: 0.1,
                              color: AppColors.colorDivider,
                              thickness: 0.4,
                            ),
                          ],
                        ));
                      }),
                )
              ]),
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

                IAppBar(context: context, text: "Select your city",textStyle: theme.text16boldWhite, color: Colors.white),

              ],
            ),
         )
    );



  }

  void _getLocationsData() {
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        //  var requestBody = jsonEncode(loginRequest);
        // Fimber.d("Request Data : $requestBody");
        // var dataa = FormData.fromMap(loginRequest);
        CommonMethods.getApiRepository().getLocationDetails().then(
          (response) {
            Fimber.d("Get Location Details");
            _waits(false);
            //_popDialog();
            //DialoguesUtils.hideProgressbar(context);
            if (response != null) {
              if (response.status == true) {
                setState(() {
                  responseData = response.locations;
                });
              } else {
                openDialog("Unable to fetch location data");
                //DialoguesUtils.showMessageDialogue(context: context,message: response.message);
              }

              //  navigateUser(response);
            }
          },
          onError: (exception) {
            //_popDialog();
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

  _waits(bool value) {
    _wait = value;
    if (mounted) setState(() {});
  }
}
