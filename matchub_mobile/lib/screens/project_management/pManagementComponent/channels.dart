import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/channels/channel_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/firebase.dart';
import 'package:matchub_mobile/services/manage_project.dart';
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
    Provider.of<ManageProject>(context, listen: false).getProject(
      widget.project.projectId,
    );
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
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(child: Text(""));
        }
        return Column(
          children: [
            ListTile(
              title: Text("Channels"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChannelsScreen(
                          project: widget.project,
                        )));
              },
            ),
            Container(
              color: Colors.transparent,
              height: 170.0,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        width: 180.0,
                        height: 200.0,
                        color: channelColors[index % 5],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   snapshot.data.documents[index].data()['name'],
                            //   style: TextStyle(
                            //       color: index % 5 == 2 || index % 5 == 3
                            //           ? Colors.white
                            //           : Colors.black),
                            // ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularStepProgressIndicator(
                                    totalSteps: 100,
                                    currentStep: 74,
                                    stepSize: 10,
                                    selectedColor: index % 5 == 0
                                        ? Colors.pink.shade300
                                        : index % 5 == 1
                                            ? Colors.yellow.shade800
                                            : index % 5 == 2
                                                ? Colors.purple
                                                : index % 5 == 3
                                                    ? Colors.red.shade300
                                                    : Colors.yellow.shade700,
                                    unselectedColor: Colors.grey[200],
                                    padding: 0,
                                    width: 80,
                                    height: 80,
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
                          ],
                        )),
                    Positioned(
                      bottom: 20.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        color: index % 5 == 0
                            ? Colors.pink.shade300.withOpacity(0.7)
                            : index % 5 == 1
                                ? Colors.yellow.shade800.withOpacity(0.7)
                                : index % 5 == 2
                                    ? Colors.purple.withOpacity(0.7)
                                    : index % 5 == 3
                                        ? Colors.red.shade300.withOpacity(0.7)
                                        : Colors.yellow.shade700
                                            .withOpacity(0.7),
                        // Colors.pink.shade300.withOpacity(0.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(snapshot.data.documents[index].data()['name'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
