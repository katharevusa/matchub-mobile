import 'package:flutter/material.dart';

void showErrorDialog(String message, context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Oops! Something went wrong...'),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
