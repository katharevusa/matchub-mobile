import 'dart:io';

import 'package:badges/badges.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class BadgeCreation extends StatefulWidget {
  Map<String, dynamic> project;
  BadgeCreation(this.project);

  @override
  _BadgeCreationState createState() => _BadgeCreationState();
}

class _BadgeCreationState extends State<BadgeCreation> {
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  List<String> badgesIcon;
  Future loadBadges;
  int selectedBadgeIndex;
  File customisedBadge;
  initState() {
    loadBadges = getAllProjectBadgeIcons();
    super.initState();
  }

  /*Retrieve a list of project badges */
  // Map<String,dynamic> badge;
  // Badge badge = new Badge;
  TextEditingController _badgeTitleController = new TextEditingController();
  getAllProjectBadgeIcons() async {
    final url = 'authenticated/getProjectBadgeIcons';
    final response = await _helper.getWODecode(url) as List;
    badgesIcon = List<String>.from(response);
  }

  createProjectBadge() async {
//create badge here
  }

  @override
  Widget build(BuildContext context) {
    // _badgeTitleController.text = badgeMap.title
    return FutureBuilder(
      future: loadBadges,
      builder: (context, snapshot) => snapshot.connectionState !=
              ConnectionState.done
          ? Container()
          : Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      initialValue: widget.project["badgeTitle"] != null
                          ? widget.project["badgeTitle"]
                          : "",
                      decoration: InputDecoration(hintText: 'Badge Title'),
                      // controller: _badgeTitleController,
                      onChanged: (text) {
                        setState(() {
                          widget.project["badgeTitle"] = text;
                        });
                      },
                    ),
                  ),
                  Text("Please select your project's badge icon"),
                  SizedBox(height: 20),
                  if (selectedBadgeIndex == null &&
                      widget.project['badgeIcon'] !=
                          null) //to Display existing badge for edit usecase
                    Container(
                        height: 100, width: 100, 
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[700], width: 0.5),
                            shape: BoxShape.circle),
                        child: ClipOval(
                            child:
                                AttachmentImage(widget.project['badgeIcon']))),
                  if (selectedBadgeIndex !=
                      null) //to Display existing badge for create usecase
                    Container(
                        height: 100, width: 100, 
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[700], width: 0.5),
                            shape: BoxShape.circle),
                        child: ClipOval(
                        child: AttachmentImage(badgesIcon[selectedBadgeIndex]))),
                  if (widget.project['uploadedBadge'] != null)
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[700], width: 0.5),
                          shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.file(widget.project['uploadedBadge'],
                            height: 100, width: 100, fit: BoxFit.cover),
                      ),
                    ),
                  SizedBox(height: 10),
                  RaisedButton(
                    child: Text("Select a badge"),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                topLeft: Radius.circular(15.0)),
                          ),
                          context: context,
                          builder: (ctx) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10),
                                  child: Text("Choose Source",
                                      style: TextStyle(
                                          fontSize:
                                              2.4 * SizeConfig.textMultiplier,
                                          color: Colors.grey[850])),
                                ),
                                ListView(shrinkWrap: true, children: [
                                  ListTile(
                                      onTap: () async {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) =>
                                                    BadgeSelectionScreen(
                                                      badgesIcon: badgesIcon,
                                                    )))
                                            .then((value) {
                                          if (value != null) {
                                            Navigator.pop(context);
                                            setState(() {
                                              selectedBadgeIndex = value;
                                              widget.project["badgeIcon"] =
                                                  badgesIcon[value];
                                              widget.project['uploadedBadge'] =
                                                  null;
                                            });
                                          }
                                        });
                                      },
                                      title: Text("MatcHub badge designs")),
                                  ListTile(
                                      onTap: () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                                type: FileType.image,
                                                allowMultiple: false);
                                        if (result != null) {
                                          widget.project['uploadedBadge'] =
                                              File(result.files.first.path);

                                          selectedBadgeIndex = null;
                                          widget.project["badgeIcon"] = null;
                                          Navigator.pop(context);
                                        }
                                      },
                                      title: Text("My own designs")),
                                ]),
                              ],
                            );
                          }).then((value) => setState(() {}));
                    },
                  )
                ]),
              ),
            ),
    );
  }
}

class BadgeSelectionScreen extends StatefulWidget {
  BadgeSelectionScreen({
    Key key,
    @required this.badgesIcon,
  }) : super(key: key);

  final List<String> badgesIcon;

  @override
  _BadgeSelectionScreenState createState() => _BadgeSelectionScreenState();
}

class _BadgeSelectionScreenState extends State<BadgeSelectionScreen> {
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Please Select ONE Badge", style: TextStyle(fontSize: 18)),
        actions: [
          FlatButton(
            padding: EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            color: kPrimaryColor,
            onPressed: () => Navigator.pop(context, selectedIndex),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            childAspectRatio: 1,
            crossAxisCount: 3),
        itemCount: widget.badgesIcon.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
              child: InkWell(
            onTap: () => {setState(() => selectedIndex = index)},
            child: Badge(
                showBadge: (selectedIndex == index),
                badgeContent: Icon(Icons.check, color: Colors.white),
                position: BadgePosition.topEnd(top: 12, end: 12),
                shape: BadgeShape.square,
                borderRadius: 20,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      height: 40 * SizeConfig.widthMultiplier,
                      width: 40 * SizeConfig.widthMultiplier,
                      child: AttachmentImage(widget.badgesIcon[index]),
                    ))),
          ));
        },
      ),
    );
  }
}
