//import 'package:flutter_html/flutter_html.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/server/doc.dart';
import 'package:fooddelivery/widget/colorloader2.dart';
import 'package:fooddelivery/widget/ibackground4.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/widgets.dart';

class DocumentsScreen extends StatefulWidget {
  final String doc;
  final String aboutText;
  final Function(String) onBack;
  DocumentsScreen({Key key, this.doc, this.onBack,this.aboutText}) : super(key: key);
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> with TickerProviderStateMixin{

  var windowWidth;
  var windowHeight;
  var _text = "";
  bool _wait = false;

  error(){
    _waits(false);
    _text = "<h3>${widget.aboutText}</h3>"; // "Something went wrong. ",
  }

  success(String _data){
    _text = _data;
    _waits(false);
  }

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  @override
  void initState() {
    _waits(true);
    docLoad(widget.doc, success, error);
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
                height: 45+MediaQuery.of(context).padding.top,
                child: IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient)
            ),

            headerWidget(context, widget.onBack, theme.colorDefaultText, ""),

            Container(
              margin: EdgeInsets.only(top: 45+MediaQuery.of(context).padding.top, left: 10, right: 10),
              /*child: SingleChildScrollView(child: Html(data: _text,))*/
                child: SingleChildScrollView(child: Text( _text,))
            ),

            if (_wait)
              Center(
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),

          ],
        ),
      ));
  }
}
