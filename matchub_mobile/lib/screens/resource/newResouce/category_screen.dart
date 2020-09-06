import 'package:flutter/material.dart';
import 'package:matchub_mobile/model/resource.dart';

class ResourceCategoryScreen extends StatefulWidget {
  static const routeName = "/resource-category-screen";
  final Resource resource;
  ResourceCategoryScreen({Key key, @required this.resource}) : super(key: key);

  @override
  _ResourceCategoryScreenState createState() =>
      _ResourceCategoryScreenState(resource);
}

class _ResourceCategoryScreenState extends State<ResourceCategoryScreen> {
  Resource resource;

  _ResourceCategoryScreenState(Resource resource) {
    this.resource = resource;
  }
  //Test
  List<String> _avail_categories = [
    "Food",
    "Instructor",
    "Transportation",
    "Techinicians"
  ];
  Widget build(BuildContext context) {
    TextEditingController _descriptionController = new TextEditingController();
    _descriptionController.text = widget.resource.description;
    bool _isChecked = false;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(64, 133, 140, 0.8),
          title: Text('Create resource'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Select category"),
            for (var item in _avail_categories)
              CheckboxListTile(
                title: Text(item),
                activeColor: Colors.red,
                checkColor: Colors.yellow,
                selected: _isChecked,
                value: _isChecked,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              )
          ],
        )));
  }
}
