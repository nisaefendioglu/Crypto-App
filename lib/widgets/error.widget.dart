import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;


  ErrorMessageWidget({
    @required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(this.message)
        ],
      ),
    );
  }

}