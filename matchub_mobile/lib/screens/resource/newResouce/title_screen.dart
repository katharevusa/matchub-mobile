import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/model/resource.dart';
import 'package:matchub_mobile/screens/resource/newResouce/description_screen.dart';

class ResourceTitleScreen extends StatelessWidget {
  static const routeName = "/resource-title-screen";
  final Resource resource;
  ResourceTitleScreen({Key key, @required this.resource}) : super(key: key);

  Widget build(BuildContext context) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = resource.title;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(64, 133, 140, 0.8),
          title: Text('Create resource'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Enter Resource title:"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _titleController,
                autofocus: true,
              ),
            ),
            RaisedButton(
                child: Text("Next"),
                onPressed: () {
                  resource.title = _titleController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResourceDescriptionScreen(resource: resource)),
                  );
                })
          ],
        )));
  }
}
