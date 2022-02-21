
import 'package:flutter/material.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/widget/ilist1.dart';

import '../../../main.dart';

nearYourTextAndIconFilter(Function() openFilter){
  return Container(
      color: appSettings.restaurantTitleColor,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(child: IList1(imageAsset: "assets/top.png", text: strings.get(39),    // Restaurants Near Your
              textStyle: theme.text16bold, imageColor: appSettings.getIconColorByMode(theme.darkMode))),
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: UnconstrainedBox(
                    child: Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/filter.png",
                          fit: BoxFit.contain, color: theme.colorDefaultText,
                        )
                    )),
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        openFilter();
                      }, // needed
                    )),
              )
            ],
          ),
        ],
      )
  );
}