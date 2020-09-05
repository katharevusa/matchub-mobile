import 'package:flutter/material.dart';
import 'package:matchub_mobile/screens/resource/model/resource.dart';
import 'package:matchub_mobile/screens/resource/newResouce/category_screen.dart';

class ResourceDescriptionScreen extends StatelessWidget {
  static const routeName = "/resource-descriptioin-screen";
  final Resource resource;
  ResourceDescriptionScreen({Key key, @required this.resource})
      : super(key: key);

  Widget build(BuildContext context) {
    TextEditingController _descriptionController = new TextEditingController();
    _descriptionController.text = resource.description;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(64, 133, 140, 0.8),
          title: Text('Create resource'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Enter Resource Description"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _descriptionController,
                autofocus: true,
              ),
            ),
            RaisedButton(
                child: Text("Next"),
                onPressed: () {
                  resource.description = _descriptionController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResourceCategoryScreen(resource: resource)),
                  );
                })
          ],
        )));
  }
}
