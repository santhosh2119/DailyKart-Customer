import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/AppColors.dart';
import 'package:fooddelivery/main.dart';

/// This is common widget manage internet connection availability of screen
class NoNetworkConnection extends StatelessWidget {
  final Function connectionCheck;
  NoNetworkConnection({this.connectionCheck});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.signal_cellular_connected_no_internet_4_bar,/*color: AppColors.colorPrimaryText,*/),
            SizedBox(height: 10.0,),
            Text('No Connection',style: TextStyle(/*color: AppColors.colorPrimaryText*/),),
            SizedBox(height: 10.0,),
            Text('Please check your connectivity and try again',style: TextStyle(/*color: AppColors.colorPrimaryText*/),),
            SizedBox(height: 10.0,),
            RaisedButton(
              /*color: AppColors.colorPrimary,*/
              child: Text('Retry',
                style: theme.text14White,
              ),
              onPressed: connectionCheck,
            ),
          ],
        ),
      ),
    );
  }
}

