import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/widget/ilabelWithIcon.dart';
import 'package:fooddelivery/widget/iline.dart';

//
// 03.10.2020 v2
// 11.10.2020 radius
//

class ICard1FileCaching extends StatelessWidget {
  final Color color;
  final String title;
  final Color colorProgressBar;
  final TextStyle titleStyle;
  final String date;
  final TextStyle dateStyle;
  final String text;
  final TextStyle textStyle;
  final String userAvatar;
  final int rating;
  final double radius;
  ICard1FileCaching({this.color = Colors.grey, this.text = "", this.textStyle, this.title = "", this.titleStyle,
    this.colorProgressBar = Colors.black,
    this.date = "", this.dateStyle, this.userAvatar, this.rating = 5,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    var _titleStyle = TextStyle(fontSize: 16);
    if (titleStyle != null)
      _titleStyle = titleStyle;
    var _textStyle = TextStyle(fontSize: 16);
    if (textStyle != null)
      _textStyle = textStyle;
    var _dateStyle = TextStyle(fontSize: 16);
    if (dateStyle != null)
      _dateStyle = dateStyle;

    var _avatar = Container();
    try {
      _avatar = Container(
        width: 30,
        height: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(),
              imageUrl: userAvatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => new Icon(Icons.error, color: colorProgressBar,),
            ),
          ),
        ),
      );
    } catch(_){

    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _avatar,
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: _titleStyle,),
                  Row(
                    children: <Widget>[
                      UnconstrainedBox(
                          child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset("assets/date.png",
                                  fit: BoxFit.contain
                              )
                          )),
                      SizedBox(width: 10,),
                      Text(date, style: _dateStyle, textAlign: TextAlign.start,),
                    ],
                  )
                ],
              ),
            ),

              ILabelIcon(radius: radius, text: rating.toStringAsFixed(1), color: Colors.white, colorBackgroud: color,
                icon: Icon(Icons.star_border, color: Colors.white,),),

            ],
          ),
          Text(text, style: _textStyle, textAlign: TextAlign.start,),
          ILine(),
        ],
      ),
    );
  }
}