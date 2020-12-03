import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/profile.dart';

import 'package:matchub_mobile/models/resources.dart';

import 'package:matchub_mobile/screens/resource/resource_detail/resourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageResource.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class OngoingResource extends StatefulWidget {
  // List<Resources> listOfResources;
  // OngoingResource(this.listOfResources);
  @override
  _OngoingResourceState createState() => _OngoingResourceState();
}

class _OngoingResourceState extends State<OngoingResource> {
  List<Resources> listOfResources = [];
  List<Resources> filteredResources = [];
  // _OngoingResourceState(this.listOfResources);
  bool _isLoading;
  @override
  void initState() {
    // resourcesFuture = retrieveResources();
    _isLoading = true;
    loadResources();
    super.initState();
  }

  loadResources() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    var accessToken = Provider.of<Auth>(context, listen: false).accessToken;
    await Provider.of<ManageResource>(context, listen: false)
        .getResources(profile, accessToken);
    setState(() {
      _isLoading = false;
    });
    listOfResources = Provider.of<ManageResource>(context).resources;
    filteredResources = listOfResources;
  }

  List _resourceStatus = [
    "All",
    "Available",
    "Busy",
  ];

  String _selected = "All";

  void selecteResource(BuildContext ctx, Resources individualResource) {
    Navigator.of(ctx, rootNavigator: true).pushNamed(
        ResourceDetailScreen.routeName,
        arguments: individualResource);
  }

  @override
  Widget build(BuildContext context) {
    //new empty resource
    final newResource = new Resources();
    return _isLoading
        ? Container(child: Center(child: Text("I am loading")))
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(FlutterIcons.filter_ant),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Filter Resource",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          value: _selected,
                          onChanged: (value) {
                            _selected = value;
                            setState(() {
                              if (value == "All") {
                                filteredResources = listOfResources;
                              } else if (value == "Available") {
                                filteredResources = listOfResources
                                    .where((e) => e.available)
                                    .toList();
                              } else {
                                filteredResources = listOfResources
                                    .where((e) => !e.available)
                                    .toList();
                              }
                            });
                          },
                          items: _resourceStatus.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredResources.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (BuildContext ctx, int index) {
                        return ListTile(
                          onTap: () =>
                              selecteResource(ctx, filteredResources[index]),
                          title: Text(
                            filteredResources[index].resourceName,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          // RotatedBox(
                          //   quarterTurns: -1,
                          //   child:
                          //       filteredResources[index].available == true
                          //           ? Text("Available",
                          //               style: TextStyle(
                          //                   fontSize: 12,
                          //                   color: Colors.black))
                          //           : Text("Busy",
                          //               style: TextStyle(
                          //                   fontSize: 12,
                          //                   color: Colors.blueGrey)),
                          // ),
                          // Container(
                          //   color: Colors.green.shade500,
                          //   height: 50,
                          //   width: 2,
                          // ),
                          // SizedBox(width: 5),
                          // Column(
                          //   mainAxisAlignment:
                          //       MainAxisAlignment.spaceEvenly,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       filteredResources[index].resourceName,
                          //       style:
                          //           Theme.of(context).textTheme.subtitle1,
                          //     ),
                          //     Text(
                          //       "  By: " +
                          //           Provider.of<Auth>(context,
                          //                   listen: false)
                          //               .myProfile
                          //               .name,
                          //       style:
                          //           Theme.of(context).textTheme.subtitle2,
                          //     ),
                          //   ],
                          // ),

                          // Container(
                          //   height: 20,
                          //   width: 60,
                          //   decoration: BoxDecoration(
                          //     color:
                          //         filteredResources[index].available == true
                          //             ? Colors.green.shade300
                          //             : Colors.red.shade200,
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: Center(
                          //     child:
                          //         filteredResources[index].available == true
                          //             ? Text(
                          //                 "Available",
                          //                 style: TextStyle(fontSize: 11),
                          //               )
                          //             : Text("Busy",
                          //                 style: TextStyle(fontSize: 11)),
                          //   ),
                          // )
                          //   ],
                          // ),
                          // subtitle: filteredResources[index].available == true
                          //     ? Text("Available")
                          //     : Text("Busy"),
                          trailing: Container(
                            width: 80.0,
                            child: filteredResources[index].photos.isNotEmpty
                                ? AttachmentImage(
                                    filteredResources[index].photos[0],
                                  )
                                : Image.asset(
                                    "assets/images/resource-default2.png"),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     child: DecorationImage(
                            //       image: AttachmentImage(images[4]),
                            //       fit: BoxFit.cover,
                            //     )),
                          ),
                        );
                        // return ListTile(
                        //   title: Text(filteredResources[index].resourceName),
                        //   onTap: () =>
                        //       selecteResource(ctx, filteredResources[index]),
                        // );
                      })
                ],
              ),
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            // floatingActionButton: FlatButton.icon(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(6)),
            //     onPressed: () => Navigator.of(context, rootNavigator: true)
            //             .push(MaterialPageRoute(
            //                 builder: (
            //           context,
            //         ) =>
            //                     ResourceCreationScreen(
            //                         newResource: newResource)))
            //             .then((value) async {
            //           setState(() {
            //             _isLoading = true;
            //           },);
            //           await loadResources();
            //           setState(() {
            //             _isLoading = false;
            //           },);
            //         }),
            //     color: kAccentColor,
            //     icon: Icon(Icons.add),
            //     label: Text(
            //       "Create resource",
            //     ),),
          );
  }
}
