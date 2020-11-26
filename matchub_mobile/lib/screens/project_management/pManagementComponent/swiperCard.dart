import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project_management/pManagementComponent/pProjectFollowers.dart';
import 'package:matchub_mobile/unused/teamMember.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../sizeconfig.dart';
import 'pTeamMembers.dart';

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
    myProfile = Provider.of<Auth>(context).myProfile;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
      child: Column(
        children: <Widget>[
          Container(color: Colors.white, child: buildCircularProgress()),
          const SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 190,
                        color: AppTheme.project5,
                        child: buildRepPoint()),
                    const SizedBox(height: 10.0),
                    InkWell(
                      child: Container(
                        height: 120,
                        color: AppTheme.project4,
                        child: buildProjectBadge(),
                      ),
                      // onTap: () {
                      //   if (myProfile.projectsOwned.indexWhere((e) =>
                      //           e.projectId == widget.project.projectId) >=
                      //       0) {
                      //     projectEndingAction(widget.project, context);
                      //   }
                      // },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 120,
                      color: AppTheme.project4,
                      child: PManagementTeamMembers(
                          widget.project), // previous pManagementTeamMember
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      height: 190,
                      color: AppTheme.project5,
                      child: PManagementProjectFollowers(widget
                          .project), // previous PManagementProjectFollower
                    ),
                  ],
                ),
              )
            ],
          )
        ],
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

  Widget buildCircularProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Text(((DateTime.now().difference(widget.project.startDate).inDays /
        //             (widget.project.endDate
        //                 .difference(widget.project.startDate)
        //                 .inDays
        //                 .toDouble()) *
        //             100)
        //         .toDouble())
        //     .toString()),
        CircularPercentIndicator(
          radius: 100.0,
          animation: true,
          animationDuration: 1200,
          lineWidth: 15.0,
          percent: widget.project.startDate.isAfter(DateTime.now())
              ? 0.0
              : DateTime.now().isAfter(widget.project.endDate)
                  ? 1.0
                  : (DateTime.now()
                              .difference(widget.project.startDate)
                              .inDays /
                          (widget.project.endDate
                              .difference(widget.project.startDate)
                              .inDays
                              .toDouble()) *
                          100) /
                      100,
          circularStrokeCap: CircularStrokeCap.butt,
          backgroundColor: AppTheme.project6.withOpacity(0.5),
          progressColor: AppTheme.project6,
        ),
        Container(
          height: 120,
          width: 150,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.project.startDate.isAfter(DateTime.now())
                  ? Text("0 %",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.project6,
                      ))
                  : DateTime.now().isAfter(widget.project.endDate)
                      ? Text("100 %",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.project6,
                          ))
                      : Text(
                          ((DateTime.now()
                                          .difference(widget.project.startDate)
                                          .inDays /
                                      (widget.project.endDate
                                          .difference(widget.project.startDate)
                                          .inDays
                                          .toDouble()) *
                                      100)
                                  .toStringAsFixed(1) +
                              " %"),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.project6,
                          )),
              Text("Overall Progress",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.project6,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRepPoint() {
    return Center(
      child: Column(
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
                    color: Colors.grey[700]),
              ),
              Text(
                "Points",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey[700]),
              ),
            ],
          ),
          LiquidCustomProgressIndicator(
            value: _animationController.value,
            direction: Axis.vertical,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(Colors.red.shade300),
            shapePath: _buildHeartPath(),
            center: Text(
              widget.project.projectPoolPoints.toString(),
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
  }

  Widget buildProjectBadge() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Project",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              Text(
                "Badge",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ],
          ),
          SizedBox(width: 10),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700], width: 0.5),
                  shape: BoxShape.circle),
              child: ClipOval(
                  child: Tooltip(
                      message: widget.project.projectBadge.badgeTitle,
                      child: Container(
                          height: 80,
                          width: 80,
                          child: AttachmentImage(
                              widget.project.projectBadge.icon)))))
        ],
      ),
    );
  }

  buildEndDate() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("END:", style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(DateFormat('EEEE').format(widget.project.endDate),
              style: TextStyle(color: Colors.white)),
          Text(
              '${widget.project.endDate.day} ' +
                  DateFormat('MMM').format(widget.project.endDate) +
                  ' ${widget.project.endDate.year}',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          Text(
              '${widget.project.endDate.hour}:${widget.project.endDate.minute}',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  buildStartDate() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "START:",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(DateFormat('EEEE').format(widget.project.startDate),
              style: TextStyle(color: Colors.white)),
          Text(
              '${widget.project.startDate.day} ' +
                  DateFormat('MMM').format(widget.project.startDate) +
                  ' ${widget.project.startDate.year}',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          Text(
              '${widget.project.startDate.hour}:${widget.project.startDate.minute}',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
