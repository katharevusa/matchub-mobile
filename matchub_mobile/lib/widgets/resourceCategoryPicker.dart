import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class ResourceCategoryPicker extends StatefulWidget {
  List categories= [];
  ResourceCategoryPicker({this.categories});
  static const routeName = '/resource-categories';
  @override
  _ResourceCategoryPickerState createState() => _ResourceCategoryPickerState();
}

class _ResourceCategoryPickerState extends State<ResourceCategoryPicker> {
  Future loadResourceCategories;
  List<ResourceCategory> listOfCategories;
  List selectedCategories= [];

  @override
  void initState() {
    selectedCategories = widget.categories;
    loadResourceCategories = loadCategories();
    super.initState();
  }

  loadCategories() async {
    final url = 'authenticated/getAllResourceCategories';
    final responseData = await ApiBaseHelper.instance.getProtected(
        url, accessToken: Provider.of<Auth>(this.context, listen: false).accessToken);
    listOfCategories = (responseData['content'] as List)
        .map((e) => ResourceCategory.fromJson(e))
        .toList();
    print(listOfCategories[0].toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resource Categories"),
        actions: [
          FlatButton(
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            color: kPrimaryColor,
            onPressed: () => Navigator.pop(context, selectedCategories),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: loadResourceCategories,
          builder: (ctx, snapshot) {
            return (snapshot.connectionState == ConnectionState.done)
                ? ListView.builder(
                    itemCount: listOfCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title:
                            Text(listOfCategories[index].resourceCategoryName),
                        value: selectedCategories.contains(
                            listOfCategories[index].resourceCategoryId),
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (bool value) {
                          setState(() {
                            int catId =
                                listOfCategories[index].resourceCategoryId;
                            if (selectedCategories.contains(catId)) {
                              selectedCategories.remove(catId);
                            } else {
                              selectedCategories.add(catId);
                            }
                          });
                        },
                      );
                    })
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
