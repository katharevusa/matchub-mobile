import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/screens/resource/model/resource.dart';
import 'package:matchub_mobile/screens/resource/newResouce/title_screen.dart';
import 'package:matchub_mobile/screens/resource/model/resource.dart';

class OngoingResource extends StatefulWidget {
  @override
  _OngoingResourceState createState() => _OngoingResourceState();
}

class _OngoingResourceState extends State<OngoingResource> {
  List _resourceStatus = [
    "All",
    "Available",
    "Busy",
  ];
  // testing only
  List<Resource> _resources = [
    Resource("Resource1", "description", ["Poverty"], "Available"),
    Resource("Resource2", "description", ["Poverty"], "Available"),
    Resource("Resource3", "description", ["Poverty"], "Available"),
    Resource("Resource4", "description", ["Poverty"], "Busy"),
    Resource("Resource5", "description", ["Poverty"], "Busy"),
    Resource("Resource6", "description", ["Poverty"], "Busy"),
  ];
  String _selected = "All";

  //List<Resource> avail = _resources.where((element) => _resources.status == "Available").toList();

  @override
  Widget build(BuildContext context) {
    //new empty resource
    final newResource = new Resource(null, null, null, null);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton(
              value: _selected,
              onChanged: (value) {
                setState(() {
                  _selected = value;
                });
              },
              items: _resourceStatus.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Expanded(
            //     child: ListView.builder(
            //         itemCount: _resources.length,
            //         itemBuilder: (BuildContext ctx, int index) {
            //           if (_selected == _resources[index].status) {
            //             return ListTile(
            //                 title: Text(_resources[index].title),
            //                 onTap: () {
            //                   Navigator.of(context).pop();
            //                   Navigator.push(
            //                       context,
            //                       new MaterialPageRoute(
            //                           builder: (context) => null));
            //                 });
            //           }
            //   if (_selected == item.status)
            //     ListTile(
            //         title: Text(item.title),
            //         onTap: () {
            //           Navigator.of(context).pop();
            //           Navigator.push(context,
            //               new MaterialPageRoute(builder: (context) => null));
            //         })
            //   return ListTile(
            //       title: Text(_resources[index].title),
            //       onTap: () {
            //         Navigator.of(context).pop();
            //         Navigator.push(
            //             context,
            //             new MaterialPageRoute(
            //                 builder: (context) => null));
            //       });
            // } else if (_selected == "Available" &&
            //     _resources[index].status != "Available") {
            //   _resources.remove(_resources[index]);
            //   return ListTile(
            //       title: Text(_resources[index].title),
            //       onTap: () {
            //         Navigator.of(context).pop();
            //         Navigator.push(
            //             context,
            //             new MaterialPageRoute(
            //                 builder: (context) => null));
            //       });
            // } else {
            //   return ListTile(
            //       title: Text(_resources[index].title),
            //       onTap: () {
            //         Navigator.of(context).pop();
            //         Navigator.push(
            //             context,
            //             new MaterialPageRoute(
            //                 builder: (context) => null));
            //       });
            // }
            // }))
            for (var item in _resources)
              if (_selected == item.status)
                ListTile(
                    title: Text(item.title),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => null));
                    })
              else if (_selected == "All" && item.status != "Expired")
                ListTile(
                  title: Text(item.title),
                )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FlatButton.icon(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ResourceTitleScreen(resource: newResource))),
          icon: Icon(Icons.add),
          label: Text("New")),
    );
  }
}
