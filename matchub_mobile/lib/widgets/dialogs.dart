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

confirmationDialog(context, String message) {
  return Center(
    child: Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(right: 16.0),
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75),
                bottomLeft: Radius.circular(75),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Row(
          children: <Widget>[
            SizedBox(width: 20.0),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                image: AssetImage(
                  './././assets/images/info-icon.png',
                ),
              ))),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Alert!",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 10.0),
                  Flexible(
                    child: Text(message),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("No"),
                          color: Colors.red,
                          colorBrightness: Brightness.dark,
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Yes"),
                          color: Colors.green,
                          colorBrightness: Brightness.dark,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
