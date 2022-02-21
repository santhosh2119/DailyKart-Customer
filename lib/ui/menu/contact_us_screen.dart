//import 'package:flutter_html/flutter_html.dart';
import 'package:fooddelivery/constants/AppConstants.dart';
import 'package:fooddelivery/constants/styles.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/doc.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactUsScreen extends StatefulWidget {
  final String doc;
  final Function(String) onBack;

  ContactUsScreen({Key key, this.doc, this.onBack}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with TickerProviderStateMixin {
  var windowWidth;
  var windowHeight;
  bool _wait = false;

  @override
  void initState() {
    // _waits(true);
    // docLoad(widget.doc, success, error);
    super.initState();
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
                  width: windowWidth,
                  height: 45 + MediaQuery.of(context).padding.top,
                  child: IBackground4(
                      width: windowWidth,
                      colorsGradient: theme.colorsGradient)),

              headerWidget(context, widget.onBack, theme.colorDefaultText,
                  AppConstants.menu_contact_us),

              Container(
                  margin: EdgeInsets.only(
                      top: 60 + MediaQuery.of(context).padding.top,
                      left: 10,
                      right: 10),
                  /*child: SingleChildScrollView(child: Html(data: "<h1>About DailyKart</h1>",))*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.dailyKart,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                              ),
                            )
                          ]),

                      SizedBox(
                        height: windowHeight * 0.02,
                      ),

                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.contact_us_address,
                            )
                          ]),

                      SizedBox(
                        height: windowHeight * 0.02,
                      ),


                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Contact Number",
                            )
                          ]),


                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            GestureDetector(
                              onTap: (){
                                 UrlLauncher.launch('tel:+917013138259');
                              },//() => UrlLauncher.launch('tel:' + contactUsResponse.mobileNumber),
                              child: Text(
                                "+91 7013138259",
                              ),
                            ),


                          ]),


                      SizedBox(
                        height: windowHeight * 0.02,
                      ),


                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "WhatsApp Link",
                            )
                          ]),


                      Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            GestureDetector(
                              onTap: (){
                                UrlLauncher.launch(AppConstants.whatsAppLink);
                              },//() => UrlLauncher.launch('tel:' + contactUsResponse.mobileNumber),
                              child: Text(
                                AppConstants.whatsAppLink,
                                style: TextStyle(
                                  color: Colors.blue
                                ),
                              ),
                            ),


                          ]),

                    ],
                  )),



              /* list.add(Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Icon(Icons.help_outline),
              SizedBox(width: 10,),
              Text(strings.get(51), style: theme.text20bold),   // "Help & support",
            ],
          ));*/

              /*Container(
              width: double.infinity,
              color: Colors.blue,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top*4.5, left: 12, right: 12),
              */ /*child: SingleChildScrollView(child: Html(data: "<h3>${AppConstants.str_about_us}</h3>",))*/ /*
                child: SingleChildScrollView(child:
                Text( "${AppConstants.contact_us_address}",style: TextStyle(
                  backgroundColor: Colors.green
                ),))
            ),*/
            ],
          ),
        ));
  }
}
