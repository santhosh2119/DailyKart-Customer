//import 'package:flutter_html/flutter_html.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/constants/styles.dart';
import 'package:fooddelivery/data/preferences/PreferenceHelper.dart';
import 'package:fooddelivery/data/services/response/rewards_response.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/doc.dart';
import 'package:fooddelivery/utils/CommonMethods.dart';
import 'package:fooddelivery/utils/dialogue_utils.dart';
import 'package:fooddelivery/utils/network_utils.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:share/share.dart';

class RewardsScreen extends StatefulWidget {
  final String doc;
  final Function(String) onBack;

  RewardsScreen({Key key, this.doc, this.onBack}) : super(key: key);

  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with TickerProviderStateMixin {
  var windowWidth;
  var windowHeight;
  bool _wait = false;
  RewardsResponse rewardsResponse = null;

  @override
  void initState() {
    super.initState();
    _waits(false);
    _loadRewardsData();
  }

  _waits(bool value) {
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  @override
  void dispose() {
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
              Container(
                  color: Colors.white,
                  width: windowWidth,
                  height: 45 + MediaQuery.of(context).padding.top,
                  child: IBackground4(
                      width: windowWidth,
                      colorsGradient: theme.colorsGradient)),
              headerWidget(
                  context, widget.onBack, theme.colorDefaultText, "Rewards"),

              /* Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),*/
              Container(
                  color: Colors.white70,
                  margin: EdgeInsets.only(
                      top: 60 + MediaQuery.of(context).padding.top,
                      left: 10,
                      right: 10),
                  /*child: SingleChildScrollView(child: Html(data: "<h1>About DailyKart</h1>",))*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Image asset
                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icon_gift.png",
                              fit: BoxFit.contain,
                              width: windowHeight * 0.08,
                              height: windowHeight * 0.08,
                            )
                          ]),
                      //Extra space
                      SizedBox(
                        height: windowHeight * 0.02,
                      ),

                      //Reward points section
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(child: Text("Reward Points ",style: TextStyle(
                                color: theme.colorPrimary,
                                fontWeight: FontWeight.bold
                            ),)),
                          ),
                          Expanded(
                            child: Container(
                                child: Text(
                                    "${rewardsResponse?.rewardBonus ?? 0}")),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: windowHeight * 0.02,
                      ),
                      //Referral amount section
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(child: Text("Referral Amount ",style: TextStyle(
                          color: theme.colorPrimary,
                          fontWeight: FontWeight.bold
                      ),)),
                          ),
                          Expanded(
                            child: Container(child:Text(
                                "${rewardsResponse?.referalBonus ?? 0}")),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: windowHeight * 0.02,
                      ),
                      //Referral code section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(child: Text("Referral code   :  ",)),
                          Container(
                              child: Text(
                            "${rewardsResponse?.userdata?.referalCode ?? ""}  ",
                            style: TextStyle(color: theme.colorPrimary),
                          )),

                          GestureDetector(
                            onTap: (){
                              Clipboard.setData(new ClipboardData(text: "${rewardsResponse?.userdata?.referalCode ?? 0}")).then((_){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Referral code copied to clipboard")));
                              });
                            },
                            child: Container(
                                child: Image.asset(
                                  "assets/icon_copy.png",
                                  fit: BoxFit.contain,
                                  width: windowWidth * 0.05,
                                  height: windowWidth * 0.05,
                                )) ,
                          )

                          /*Expanded(
                            child: Container(child: Text("Referral code :")),
                          ),
                          Expanded(
                            child: Container(child: Text("0")),
                          ),
                          Expanded(
                            child: Container(child: Text("01")),
                          ),*/
                        ],
                      ),

                      SizedBox(
                        height: windowHeight * 0.02,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                child: Text(
                                    "Note : You can earn more reward points by sharing our app with your friends and relatives")),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: windowHeight * 0.02,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                child: ElevatedButton(
                              child: Text("Share App"),
                              onPressed: () {
                                print("Share App clicked");
                                Share.share('check out my website https://example.com');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: theme.colorPrimary, // background
                                onPrimary: Colors.white, // foreground
                              ),
                            )),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  _loadRewardsData() {
    NetworkUtils.isNetwork().then((intenet) {
      if (intenet != null && intenet) {
        // Internet Present Case
        Fimber.d("isNetwork Available");

        var body = {
          'userid': '${PreferenceHelper.getString(AppConstants.PREF_USER_ID)}'
        };

        CommonMethods.getApiRepository().getUserRewardsDetails(body).then(
          (response) {
            Fimber.d("getUserRewardsDetails fetched Success");
            _waits(false);
            //_popDialog();
            //DialoguesUtils.hideProgressbar(context);
            if (response != null) {
              print("Response : $response");
              //userFavoritesList = response.favouriteData;
              setState(() {
                rewardsResponse = response;
                //userFavoritesList = response.favouriteData;
              });
            }
          },
          onError: (exception) {
            _waits(false);
          },
        );

        _waits(true);
      } else {
        // No-Internet Case
        Fimber.d("isNetwork Not Available");
        DialoguesUtils.noInternet(context);
      }
    });
  }
}
