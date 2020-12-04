import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/attachmentHelper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/home/competition/joinCompetition.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../sizeConfig.dart';

class CompetitionDetail extends StatefulWidget {
  static const routeName = "/competition-detail";
  Competition competition;

  CompetitionDetail({this.competition});
  @override
  _CompetitionDetailState createState() => _CompetitionDetailState();
}

class _CompetitionDetailState extends State<CompetitionDetail> {
  Profile myProfile;
  List<String> documentKeys;
  List<Project> result = [];
  Future loader;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  bool isLoading = true;
  @override
  void initState() {
    loader = getResults();
    super.initState();
  }

  getResults() async {
    setState(() => isLoading = true);
    result = [];
    final url =
        'authenticated/getCompetitionResults?competitionId=${widget.competition.competitionId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List).forEach((e) => result.add(Project.fromJson(e)));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    return isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppTheme.appBackgroundColor,
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  color: Colors.grey[850],
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              actions: [],
              backgroundColor: AppTheme.appBackgroundColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 200,
                        child: Swiper(
                          itemCount: widget.competition.photos.length,
                          autoplay: true,
                          curve: Curves.easeIn,
                          itemBuilder: (BuildContext context, int index) {
                            NetworkImage(
                              "${ApiBaseHelper.instance.baseUrl}${widget.competition.photos[index].substring(30)}",
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 200,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.competition.competitionTitle,
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Text(widget.competition.competitionDescription,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.competition.documents.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * SizeConfig.heightMultiplier,
                          horizontal: 8.0 * SizeConfig.widthMultiplier),
                      child: Text(
                        "ATTACHMENTS",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                    ),
                    Container(
                      color: AppTheme.appBackgroundColor,
                      height: 28 * SizeConfig.widthMultiplier,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0 * SizeConfig.widthMultiplier),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () async {
                                  List documentKeys = widget
                                      .competition.documents.keys
                                      .toList();
                                  String fileName = (widget.competition
                                      .documents[documentKeys[index]]);
                                  String url = ApiBaseHelper.instance.baseUrl +
                                      fileName.substring(30);
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.widthMultiplier,
                                      vertical:
                                          2 * SizeConfig.heightMultiplier),
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      offset: Offset(4, 10),
                                      blurRadius: 6,
                                      color: Colors.grey[300].withOpacity(0.10),
                                    ),
                                    BoxShadow(
                                      offset: Offset(-4, 10),
                                      blurRadius: 6,
                                      color: Colors.grey[300].withOpacity(0.10),
                                    ),
                                  ]),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            1 * SizeConfig.heightMultiplier),
                                        color: Colors.white,
                                        width: 20 * SizeConfig.widthMultiplier,
                                        // height:
                                        //     20 * SizeConfig.widthMultiplier,
                                        child: getDocumentImage(
                                            documentKeys[index]),
                                      )),
                                ),
                              ),
                          itemCount: widget.competition.documents.keys
                              .toList()
                              .length),
                    )
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.group,
                                  size: 24, color: Colors.grey[700]),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  widget.competition.projects.length.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text("Projects involved",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700])),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 24, color: Colors.grey[700]),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  widget.competition.prizeMoney
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: kKanbanColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text("Prize",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.competition.endDate.isAfter(DateTime.now())
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppTheme.project4,
                            ),
                            child: Center(
                              child: Text(
                                  "Start Date: ${DateFormat('dd MMM yyyy ').format(widget.competition.startDate)}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ),
                          ),
                        )
                      : Container(),
                  widget.competition.endDate.isAfter(DateTime.now())
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppTheme.project5,
                            ),
                            child: Center(
                              child: Text(
                                  "End Date: ${DateFormat('dd-MMM-yyyy ').format(widget.competition.endDate)}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppTheme.project2,
                            ),
                            child: Center(
                              child: Text(
                                  "Competition Ended On: ${DateFormat('dd-MMM-yyyy ').format(widget.competition.endDate)}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54)),
                            ),
                          ),
                        ),
                  //join competition
                  widget.competition.endDate.isAfter(DateTime.now())
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              minWidth: 120,
                              color: AppTheme.project2.withOpacity(0.2),
                              splashColor: AppTheme.project2,
                              child: Text('Join Competition'),
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).push(MaterialPageRoute(
                                    builder: (_) => JoinCompetition(
                                        competition: widget.competition)));
                              },
                            ),
                            FlatButton(
                              minWidth: 120,
                              color: AppTheme.project2.withOpacity(0.2),
                              splashColor: AppTheme.project2,
                              child: Text('Get Voter ID'),
                              onPressed: () {
                                getVoterId();
                              },
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  //list of projects in the competition
                  if (widget.competition.endDate.isAfter(DateTime.now())) ...{
                    for (Project p in widget.competition.projects) ...{
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ProjectDetailScreen(
                                      project: p,
                                    ))),
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: 180,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "${ApiBaseHelper.instance.baseUrl}${p.projectProfilePic.substring(30)}",
                                        ),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300]
                                              .withOpacity(0.15),
                                          offset: Offset(5.0, 5.0),
                                          blurRadius: 10.0)
                                    ]),
                              )),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        p.projectTitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 10),
                                      // Text(
                                      //   p.competitionVotes.toString() + ' votes',
                                      //   style: TextStyle(
                                      //       fontSize: 20.0,
                                      //       color: AppTheme.project2,
                                      //       fontWeight: FontWeight.w700),
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RaisedButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Text(
                                              'Vote',
                                              style: TextStyle(
                                                  color: AppTheme.project2),
                                            ),
                                            onPressed: () =>
                                                _votingDialog(context, p),
                                          ),
                                        ],
                                      ),
                                      // FlatButton(
                                      //   height: 8,
                                      //   minWidth: 50,
                                      //   child: Text('Vote'),
                                      //   onPressed: () {},
                                      // )
                                    ],
                                  ),
                                  margin:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[300]
                                                .withOpacity(0.50),
                                            offset: Offset(5.0, 5.0),
                                            blurRadius: 10.0)
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    }
                  } else ...{
                    for (Project p in result) ...{
                      Column(children: [
                        // Text((result.indexOf(p) + 1).toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            result.indexOf(p) == 0
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              './././assets/images/goldMedal.png'),
                                          fit: BoxFit.fill),
                                    ),
                                  )
                                : result.indexOf(p) == 1
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  './././assets/images/silverMedal.png'),
                                              fit: BoxFit.fill),
                                        ),
                                      )
                                    : Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  './././assets/images/bronzeMedal.png'),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                            Container(
                              width: 110.0,
                              height: 110.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.yellow.shade700),
                              ),
                              margin:
                                  const EdgeInsets.only(top: 32.0, left: 16.0),
                              padding: const EdgeInsets.all(3.0),
                              child: ClipOval(
                                child: AttachmentImage(
                                  p.projectProfilePic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(p.projectTitle,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ]),
                    }
                  }
                ],
              ),
            ),
          );
  }

  getVoterId() async {
    final url =
        "authenticated/createVotingDetailsForExistingUsers?competitionId=${widget.competition.competitionId}&accountId=${myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.postProtected(
        url,
      );
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }

  _votingDialog(BuildContext context, Project p) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VotingDialog(widget.competition, p);
      },
    );
  }
}

class VotingDialog extends StatefulWidget {
  Competition competition;
  Project project;
  VotingDialog(this.competition, this.project);

  @override
  _VotingDialogState createState() => _VotingDialogState();
}

class _VotingDialogState extends State<VotingDialog> {
  final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);

  final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);

  String secret;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 800,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "Voting Form",
                    style: TextStyle(color: Colors.green),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "TO PROJECT",
                            style: label,
                          ),
                          Text(widget.project.projectTitle),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'ENTER VOTER SECRET',
                      labelStyle:
                          TextStyle(color: Colors.grey[850], fontSize: 14),
                      fillColor: Colors.grey[100],
                      hoverColor: Colors.grey[100],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[850],
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      secret = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  FlatButton(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Submit Vote"),
                    onPressed: () async {
                      await submitVote();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submitVote() async {
    final url =
        "authenticated/castVoteForCompetitionProject?competitionId=${widget.competition.competitionId}&projectId=${widget.project.projectId}&voterSecret=${secret}";
    try {
      final response = await ApiBaseHelper.instance.postProtected(
        url,
      );
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }
}
