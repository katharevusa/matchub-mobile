import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/kanban/kanban.dart';
import 'package:matchub_mobile/screens/project_management/channels/channel_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/CircularStepProgressIndicator.dart';
import 'package:provider/provider.dart';

class PManagementChannels extends StatefulWidget {
  Project project;
  PManagementChannels(this.project);

  @override
  _PManagementChannelsState createState() => _PManagementChannelsState();
}

class _PManagementChannelsState extends State<PManagementChannels> {
  Stream chatRooms;
  List<Color> channelColors = <Color>[
    Color(0xffFFC6D9),
    Color(0xffFFE1C6),
    Color(0xff48284A),
    Color(0xff916C80),
    Color(0xffFFF7AE),
  ];
  @override
  void initState() {
    getProjectChannels();
    super.initState();
  }

  getProjectChannels() async {
    await DatabaseMethods()
        .getProjectChannels("${widget.project.projectId}",
            Provider.of<Auth>(context, listen: false).myProfile.uuid)
        .then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(widget.project.projectId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.project =
        Provider.of<ManageProject>(context, listen: false).managedProject;
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(child: Text("No channels yet"));
        }
        return Column(
          children: [
            ListTile(
              title: Text("Channels", style: TextStyle(color: Colors.black)),
              trailing: MaterialButton(
                elevation: 0,
                textColor: Colors.white,
                color: Colors.black.withOpacity(0.5),
                height: 0,
                child: Icon(Icons.keyboard_arrow_right),
                minWidth: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(2.0),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChannelsScreen(
                            project: widget.project,
                          )));
                },
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChannelsScreen(
                          project: widget.project,
                        )));
              },
            ),
            snapshot.data.documents.length != 0
                ? Container(
                    color: Colors.transparent,
                    height: 200.0,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(KanbanView.routeName, arguments: {
                              "channelData":
                                  snapshot.data.documents[index].data(),
                              "project": widget.project
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: AppTheme.project4.withOpacity(0.5),
                              ),
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                CircularStepProgressIndicator(
                                              totalSteps: 100,
                                              currentStep: 74,
                                              stepSize: 10,
                                              selectedColor: AppTheme.project4,
                                              unselectedColor: Colors.grey[200],
                                              padding: 0,
                                              width: 40,
                                              height: 40,
                                              selectedStepSize: 15,
                                              roundedCap: (_, __) => true,
                                            ),
                                          ),
                                          Text(
                                            "100%",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data.documents[index]
                                              .data()['name'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      RaisedButton(
                                        elevation: 0,
                                        padding: const EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text("Enter"),
                                        color: AppTheme.project5,
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "No channel has been created.",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
          ],
        );
      },
    );
  }
}
