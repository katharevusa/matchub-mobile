import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';

class ProjectDetailScreen extends StatefulWidget {
  static const routeName = "/project-details";
  int projectId;

  ProjectDetailScreen({this.projectId});

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Future loadProject;
  Project project;
  @override
  void initState() {
    loadProject = getProjects();
    super.initState();
  }

  getProjects() async {
    final responseData = await ApiBaseHelper().getProtected(
        "authenticated/getProject?projectId=${widget.projectId}",
        Provider.of<Auth>(context, listen: false).accessToken);

    project = Project.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(15.0),
            child: IconButton(
              color: Colors.grey[850],
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            IconButton(
              alignment: Alignment.bottomCenter,
              visualDensity: VisualDensity.comfortable,
              icon: Icon(
                FlutterIcons.ellipsis_v_faw5s,
                size: 20,
                color: Colors.grey[800],
              ),
              onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => buildMorePopUp(context))
                  .then((value) => setState(() {
                        loadProject = getProjects();
                      })),
            ),
          ],
          backgroundColor: AppTheme.appBackgroundColor,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: loadProject,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.done
              ? SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0 * SizeConfig.widthMultiplier),
                          child: Text(
                            project.projectTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 3.2 * SizeConfig.textMultiplier),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 1 * SizeConfig.heightMultiplier,
                              left: 8.0 * SizeConfig.widthMultiplier),
                          child: Text(
                              "${project.upvotes} upvotes | ${project.userFollowers.length} following",
                              style: AppTheme.unSelectedTabLight),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: false,
                            aspectRatio: 1.8,
                            viewportFraction: 1.0,
                            enlargeCenterPage: true,
                          ),
                          items: imageSliders,
                        ),

                        // ExpandableText(
                        //   project.projectDescription,
                        //   expandText: 'show more',
                        //   collapseText: 'show less',
                        //   maxLines: 3,
                        //   linkColor: Colors.blue,
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.5 * SizeConfig.heightMultiplier,
                              horizontal: 8.0 * SizeConfig.widthMultiplier),
                          child: Text(
                            "PROJECT DESCRIPTION",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.5 * SizeConfig.heightMultiplier,
                              horizontal: 8.0 * SizeConfig.widthMultiplier),
                          child: ReadMoreText(
                            project.projectDescription +
                                project.projectDescription +
                                "\n\nStatus: ${project.projStatus}"
                                    "\nStart Date: ${DateFormat('dd-MMM-yyyy ').format(project.startDate)}" +
                                "\nEnd Date: ${DateFormat('dd-MMM-yyyy ').format(project.endDate)}\n",
                            trimLines: 3,
                            style: TextStyle(
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.justify,
                            colorClickableText: kSecondaryColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...Show more',
                            trimExpandedText: 'show less',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 1.5 * SizeConfig.heightMultiplier,
                              right: 8.0 * SizeConfig.widthMultiplier,
                              left: 8.0 * SizeConfig.widthMultiplier),
                          child: Text(
                            "MEET THE FOUNDERS",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.all(0),
                          color: AppTheme.appBackgroundColor,
                          height: 16 * SizeConfig.heightMultiplier,
                          child: ListView.builder(
                              cacheExtent: 20,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.0 * SizeConfig.widthMultiplier),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                // print(project.projectOwners[index].name);
                                return Container(
                                  padding: EdgeInsets.all(0),
                                  // padding: EdgeInsets.symmetric(
                                  // horizontal:
                                  //     2 * SizeConfig.widthMultiplier,
                                  // vertical:
                                  //     1 * SizeConfig.heightMultiplier),
                                  height: 16 * SizeConfig.heightMultiplier,
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          2 * SizeConfig.widthMultiplier,
                                      vertical:
                                          2 * SizeConfig.heightMultiplier),
                                  child: Column(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                            color: Colors.white,
                                            width:
                                                16 * SizeConfig.widthMultiplier,
                                            // height:
                                            //     20 * SizeConfig.widthMultiplier,
                                            child: Image.asset(
                                              "assets/images/avatar.png",
                                              fit: BoxFit.contain,
                                            ))),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              1 * SizeConfig.heightMultiplier,
                                          horizontal:
                                              1 * SizeConfig.widthMultiplier),
                                      child: Text(
                                          project.projectOwners[index].name),
                                    )
                                  ]),
                                );
                              },
                              itemCount: project.projectOwners.length),
                        ),
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
                              itemBuilder: (context, index) => Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            2 * SizeConfig.widthMultiplier,
                                        vertical:
                                            2 * SizeConfig.heightMultiplier),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        offset: Offset(4, 10),
                                        blurRadius: 6,
                                        color:
                                            Colors.grey[400].withOpacity(0.15),
                                      ),
                                      BoxShadow(
                                        offset: Offset(-4, 10),
                                        blurRadius: 6,
                                        color:
                                            Colors.grey[400].withOpacity(0.15),
                                      ),
                                    ]),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Container(
                                            padding: EdgeInsets.all(1 *
                                                SizeConfig.heightMultiplier),
                                            color: Colors.white,
                                            width:
                                                20 * SizeConfig.widthMultiplier,
                                            // height:
                                            //     20 * SizeConfig.widthMultiplier,
                                            child: Image.asset(
                                              iconList[index],
                                              fit: BoxFit.contain,
                                            ))),
                                  ),
                              itemCount: iconList.length),
                        )
                      ]),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  Container buildMorePopUp(BuildContext context) {
    return Container(
        height: 250,
        child: Column(
          children: [
            FlatButton(
                onPressed: () {
                  Share.share(
                      'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this project on: ${project.projectTitle}\nhttp://localhost:3000/project/uniqueIdentifier');
                },
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.share_square_faw5s,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Share", style: AppTheme.titleLight),
                  ],
                )),
            FlatButton(
                onPressed: () {},
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.user_plus_faw5s,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Follow", style: AppTheme.titleLight),
                  ],
                )),
            FlatButton(
                onPressed: () {},
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.user_friends_faw5s,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Join Team", style: AppTheme.titleLight),
                  ],
                )),
            FlatButton(
                onPressed: () {},
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        FlutterIcons.donate_faw5s,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Contribute Resource", style: AppTheme.titleLight),
                  ],
                )),
          ],
        ));
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: Offset(4, 10),
              blurRadius: 10,
              color: Colors.grey[300].withOpacity(0.2),
            ),
            BoxShadow(
              offset: Offset(-4, 10),
              blurRadius: 30,
              color: Colors.grey[300].withOpacity(0.2),
            ),
          ]),
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 6,
              vertical: SizeConfig.heightMultiplier * 2),
          child: Material(
            elevation: 1*SizeConfig.heightMultiplier,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                          // 'No. ${imgList.indexOf(item)} image',
                          '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
final List<String> imgList = [
  // 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  // 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
];
final List<String> iconList = [
  "assets/icons/word.png",
  "assets/icons/ppt.png",
  "assets/icons/excel.png",
  "assets/icons/pdf.png",
  "assets/icons/pdf.png",
  "assets/icons/pdf.png",
];
