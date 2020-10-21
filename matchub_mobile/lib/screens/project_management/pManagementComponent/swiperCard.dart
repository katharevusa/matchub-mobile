import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class PManagementSwiperCard extends StatefulWidget {
  Project project;
  PManagementSwiperCard(this.project);

  @override
  _PManagementSwiperCardState createState() => _PManagementSwiperCardState();
}

class _PManagementSwiperCardState extends State<PManagementSwiperCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Profile myProfile;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.project = Provider.of<ManageProject>(context).managedProject;
    myProfile = Provider.of<Auth>(context).myProfile;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.transparent,
        ),
        child: Swiper(
          itemCount: 3,
          itemBuilder: (context, index) {
            return index == 0
                ? Column(
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 100.0,
                        animation: true,
                        animationDuration: 1200,
                        lineWidth: 15.0,
                        percent: 0.74,
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor: Color(0xFF48284A).withOpacity(0.5),
                        progressColor: Color(0xFF48284A),
                      ),
                      Text("74 %",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF916C80),
                          )),
                      Text("Goals Overall Progess",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF916C80),
                          )),
                    ],
                  )
                : index == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF48284A),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "START:",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                    DateFormat('EEEE')
                                        .format(widget.project.startDate),
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    '${widget.project.startDate.day} ' +
                                        DateFormat('MMM')
                                            .format(widget.project.startDate) +
                                        ' ${widget.project.startDate.year}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                                Text(
                                    '${widget.project.startDate.hour}:${widget.project.startDate.minute}',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF48284A)),
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      widget.project.projStatus == "COMPLETED"
                                          ? Colors.green
                                          : widget.project.projStatus ==
                                                  "TERMINATED"
                                              ? Colors.yellow
                                              : Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("END:",
                                      style: TextStyle(
                                          color: Color(0xFF48284A),
                                          fontSize: 20)),
                                  Text(
                                      DateFormat('EEEE')
                                          .format(widget.project.endDate),
                                      style:
                                          TextStyle(color: Color(0xFF48284A))),
                                  Text(
                                      '${widget.project.endDate.day} ' +
                                          DateFormat('MMM')
                                              .format(widget.project.endDate) +
                                          ' ${widget.project.endDate.year}',
                                      style: TextStyle(
                                          color: Color(0xFF48284A),
                                          fontSize: 15)),
                                  Text(
                                      '${widget.project.endDate.hour}:${widget.project.endDate.minute}',
                                      style:
                                          TextStyle(color: Color(0xFF48284A))),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (myProfile.projectsOwned
                                  .contains(widget.project)) {
                                projectEndingAction(widget.project, context);
                              }
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Reputation",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF48284A)),
                                ),
                                Text(
                                  "Points",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF48284A)),
                                ),
                              ],
                            ),
                            LiquidCustomProgressIndicator(
                              value: _animationController.value,
                              direction: Axis.vertical,
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.red.shade300),
                              shapePath: _buildHeartPath(),
                              center: Text(
                                widget.project.upvotes.toString(),
                                style: TextStyle(
                                  color: Color(0xFF916C80),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }

  Path _buildHeartPath() {
    return Path()
      ..moveTo(55, 15)
      ..cubicTo(55, 12, 50, 0, 30, 0)
      ..cubicTo(0, 0, 0, 37.5, 0, 37.5)
      ..cubicTo(0, 55, 20, 77, 55, 95)
      ..cubicTo(90, 77, 110, 55, 110, 37.5)
      ..cubicTo(110, 37.5, 110, 0, 80, 0)
      ..cubicTo(65, 0, 55, 12, 55, 15)
      ..close();
  }

  projectEndingAction(Project project, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(10),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Expanded(
                  child: project.projStatus == "ACTIVE"
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Terminate Project Early"),
                                  onPressed: () async {
                                    await terminateProject();
                                    Navigator.pop(context, true);
                                  },
                                ),
                                Divider(),
                                FlatButton(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Mark Project as Complete"),
                                  onPressed: () async {
                                    await markProjectAsComplete();
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            )
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "This project has already been " +
                                  project.projStatus,
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
            ),
          ),
        );
      },
    );
  }

  terminateProject() async {
    final url =
        "authenticated/terminateProject?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );

      // await Provider.of<ManageProject>(context, listen: false)
      //     .getAllOwnedProjects(Provider.of<Auth>(context).myProfile,
      //         Provider.of<Auth>(context, listen: false).accessToken);
      print("Success");
      Navigator.of(this.context).pop(true);
    } catch (error) {
      // final responseData = error.body as Map<String, dynamic>;
      print("Failure");
      showErrorDialog(error.toString(), this.context);
    }
  }

  markProjectAsComplete() async {
    final url =
        "authenticated/completeProject?projectId=${widget.project.projectId}&profileId=${myProfile.accountId}";
    try {
      // var accessToken = Provider.of<Auth>(this.context,listen: false).accessToken;
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      await Provider.of<ManageProject>(context, listen: false)
          .getProject(widget.project.projectId);
      print("Success");
      Navigator.of(this.context).pop("Completed-Project");
    } catch (error) {
      showErrorDialog(error.toString(), this.context);
      print("Failure");
    }
  }
}
