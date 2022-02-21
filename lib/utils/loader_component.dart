
import 'package:flutter/material.dart';

/// This is common widget manage loading ui of screen
class LoaderComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Please wait...",style: TextStyle(/*color: AppColors.colorPrimaryText*/),),
            SizedBox(height: 20.0),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}