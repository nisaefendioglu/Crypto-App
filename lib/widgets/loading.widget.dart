import 'package:flutter/material.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

}