import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/home/competition/competitionDetail.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manageCompetition.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class ViewAllCompetition extends StatefulWidget {
  @override
  _ViewAllCompetitionState createState() => _ViewAllCompetitionState();
}

class _ViewAllCompetitionState extends State<ViewAllCompetition> {
  Profile myProfile;
  List<Competition> activeCompetitions = [];
  List<Competition> allCompetitions = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Future loader;
  @override
  void initState() {
    loadActiveCompetitions();
    print('=======');
    super.initState();
  }

  // getAllActiveCompetition() async {
  //   activeCompetitions = [];
  //   myProfile = Provider.of<Auth>(context).myProfile;
  //   final url = 'authenticated/getAllActiveCompetitions';
  //   final responseData = await _apiHelper.getWODecode(url);
  //   (responseData as List)
  //       .forEach((e) => activeCompetitions.add(Competition.fromJson(e)));
  // }
  loadActiveCompetitions() async {
    await Provider.of<ManageCompetition>(context, listen: false)
        .getAllActiveCompetition();
    await Provider.of<ManageCompetition>(context, listen: false)
        .getAllCompetition();
  }

  @override
  Widget build(BuildContext context) {
    activeCompetitions =
        Provider.of<ManageCompetition>(context).activeCompetitions;
    allCompetitions = Provider.of<ManageCompetition>(context).allCompetitions;
    myProfile = Provider.of<Auth>(context).myProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Competitions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // _buildAvatar(),
            _buildInfo(),
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                "Ongoing Competitions",
                style: TextStyle(
                  // color: Colors.white.withOpacity(0.85),
                  height: 1.4,
                  fontSize: 18,
                ),
              ),
            ),
            _buildCompetition(activeCompetitions),
            Container(
              color: Colors.white.withOpacity(0.85),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              width: double.infinity,
              height: 1.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                "Past Competitions",
                style: TextStyle(
                  // color: Colors.white.withOpacity(0.85),
                  height: 1.4,
                  fontSize: 18,
                ),
              ),
            ),
            allCompetitions.isNotEmpty
                ? _buildCompetition(allCompetitions)
                : SizedBox.shrink(),
            _buildbuton(context),
          ],
        ),
      ),
    );
  }

  _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Text(
            "Hello " +
                myProfile.name +
                '.\n' +
                "Welcome to MatcHub Competition section. \n" +
                "In MatcHub Competition, you can join any of the active competition with your owned projects and stand a chance to win attractive prices. You could also vote for the projects in other competitions.",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 225.0,
            height: 1.0,
          ),
          Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       "Your participation..",
              //       style: TextStyle(
              //           // color: Colors.white.withOpacity(0.85),
              //           height: 1.4,
              //           fontSize: 18,
              //           color: AppTheme.project3),
              //     ),
              //     for (Project p in myProfile.projectsOwned) ...{
              //       if (p.competition != null)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               p.projectTitle + ':',
              //               style: TextStyle(
              //                 color: Colors.white.withOpacity(0.85),
              //                 height: 1.4,
              //               ),
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   p.competitionVotes.toString() + ' VOTES',
              //                   style: TextStyle(
              //                     color: Colors.black,
              //                     fontSize: 20,
              //                     height: 1.4,
              //                   ),
              //                 ),
              //                 Text(
              //                   p.competition.competitionTitle,
              //                   style: TextStyle(
              //                     color: AppTheme.project3,
              //                     fontSize: 15,
              //                     height: 1.4,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //     }
              //   ],
              // ),
              )
        ],
      ),
    );
  }

  _buildbuton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            'Back',
            style: TextStyle(color: Colors.white70),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _buildCompetition(List<Competition> activeCompetitions) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox.fromSize(
        size: Size.fromHeight(245.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: activeCompetitions.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(
                      builder: (_) => CompetitionDetail(
                          competition: activeCompetitions[index])));
                },
                child: CompetitionCard(activeCompetitions[index]));
          },
        ),
      ),
    );
  }
}

class CompetitionCard extends StatelessWidget {
  Competition competition;
  CompetitionCard(this.competition);

  BoxDecoration _buildShadowAndRoundedCorners() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 2.0,
          blurRadius: 10.0,
          color: Colors.black26,
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 4.0,
        right: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            competition.competitionTitle,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            competition.competitionDescription,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style:
                TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "View more>>",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          competition.endDate.isAfter(DateTime.now())
              ? Row(
                  children: [
                    Text(
                      "Ending in ",
                      style: TextStyle(fontSize: 15),
                    ),
                    SlideCountdownClock(
                      duration: Duration(
                        days: competition.endDate
                            .difference(DateTime.now())
                            .inDays,
                      ),
                      slideDirection: SlideDirection.Up,
                      separator: ":",
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      shouldShowDays: true,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      "Ended on ${DateFormat('dd MMM yyyy ').format(competition.endDate)}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
          Text('Prize:'),
          Text(
            '\$' + competition.prizeMoney.toString() + '0',
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      decoration: _buildShadowAndRoundedCorners(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: _buildInfo()),
        ],
      ),
    );
  }
}
