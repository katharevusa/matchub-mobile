import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../sizeconfig.dart';
import '../../../style.dart';

class PFounderTeamAttachBadgeSDG extends StatelessWidget {
  Project project;
  PFounderTeamAttachBadgeSDG(this.project);
  List<String> documentKeys;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...buildFoundersRow(),
        ...buildTeamMemberRow(project.teamMembers),
        ...buildAttachments(),
        ...buildBadgeRow(),
        // ...buildSDGRow(),
      ],
    );
  }

  List<Widget> buildAttachments() {
    return (project.documents.isNotEmpty)
        ? [
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
                          String fileName =
                              (project.documents[documentKeys[index]]);
                          String url = ApiBaseHelper.instance.baseUrl +
                              fileName.substring(30);
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                          // OpenFile.open(
                          //     "https://192.168.1.55:8443/api/v1/files/att-7062382057131087005.pdf");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 2 * SizeConfig.widthMultiplier,
                              vertical: 2 * SizeConfig.heightMultiplier),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              offset: Offset(4, 10),
                              blurRadius: 6,
                              color: Colors.grey[400].withOpacity(0.15),
                            ),
                            BoxShadow(
                              offset: Offset(-4, 10),
                              blurRadius: 6,
                              color: Colors.grey[400].withOpacity(0.15),
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
                                child: getDocumentImage(documentKeys[index]),
                              )),
                        ),
                      ),
                  itemCount: project.documents.keys.toList().length),
            )
          ]
        : [SizedBox.shrink()];
  }

  List<Widget> buildFoundersRow() {
    return [
      Padding(
        padding: EdgeInsets.only(
            top: 1.5 * SizeConfig.heightMultiplier,
            right: 8.0 * SizeConfig.widthMultiplier,
            left: 8.0 * SizeConfig.widthMultiplier),
        child: Text(
          "MEET THE FOUNDERS",
          style: TextStyle(
              color: Colors.grey[600], fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      Container(
        // padding: EdgeInsets.all(0),
        // margin: EdgeInsets.all(0),
        // color: AppTheme.appBackgroundColor,
        height: 14 * SizeConfig.heightMultiplier,
        child: ListView.builder(
            cacheExtent: 20,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: 6.0 * SizeConfig.widthMultiplier),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(0),
                // padding: EdgeInsets.symmetric(
                // horizontal:
                //     2 * SizeConfig.widthMultiplier,
                // vertical:
                //     1 * SizeConfig.heightMultiplier),
                // constraints:
                //     BoxConstraints(minHeight: 18 * SizeConfig.heightMultiplier),
                margin: EdgeInsets.symmetric(
                    horizontal: 2 * SizeConfig.widthMultiplier,
                    vertical: 2 * SizeConfig.heightMultiplier),
                child: Column(children: [
                  ClipOval(
                      // borderRadius: BorderRadius.circular(50),
                      child: Container(
                          color: Colors.white,
                          height: 16 * SizeConfig.widthMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          child: AttachmentImage(
                              project.projectOwners[index].profilePhoto))),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 20 * SizeConfig.widthMultiplier,
                          minWidth: 15 * SizeConfig.widthMultiplier),
                      child: Text(
                        project.projectOwners[index].name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  )
                ]),
              );
            },
            itemCount: project.projectOwners.length),
      )
    ];
  }

  List<Widget> buildBadgeRow() {
    print(project.projectBadge);
    if (project.projectBadge != null) {
      return [
        Padding(
          padding: EdgeInsets.only(
              top: 1.5 * SizeConfig.heightMultiplier,
              right: 8.0 * SizeConfig.widthMultiplier,
              left: 8.0 * SizeConfig.widthMultiplier),
          child: Text(
            "PROJECT BADGE",
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: SizeConfig.textMultiplier * 2),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 8.0 * SizeConfig.widthMultiplier),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700], width: 0.5),
                shape: BoxShape.circle),
            child: ClipOval(
                child: Tooltip(
                    message: project.projectBadge.badgeTitle,
                    child: AttachmentImage(project.projectBadge.icon))))
      ];
    } else {
      return [SizedBox.shrink()];
    }
    ;
  }

  Widget _buildAvatar(profile, {double radius = 80}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: radius,
      child: ClipOval(
        child: AttachmentImage(profile.profilePhoto),
      ),
    );
  }

  List<Widget> buildTeamMemberRow(List<TruncatedProfile> members) {
    return (members.isNotEmpty)
        ? [
            Padding(
              padding: EdgeInsets.only(
                  top: 1.5 * SizeConfig.heightMultiplier,
                  right: 8.0 * SizeConfig.widthMultiplier,
                  left: 8.0 * SizeConfig.widthMultiplier),
              child: Text(
                "MEET THE TEAM MEMBERS",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: SizeConfig.textMultiplier * 2),
              ),
            ),
            Container(
                // height: 60,
                width: SizeConfig.widthMultiplier * 100,
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.widthMultiplier),
                margin: EdgeInsets.symmetric(
                    vertical: 5 * SizeConfig.widthMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        ...members
                            .asMap()
                            .map(
                              (i, e) => MapEntry(
                                i,
                                Transform.translate(
                                  offset: Offset(i * 40.0, 0),
                                  child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: _buildAvatar(e, radius: 30)),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => ViewOrganisationMembersScreen(
                        //             user: widget.profile)));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(width: 1, color: Colors.black),
                          image: DecorationImage(
                              image: AssetImage(
                                  './././assets/images/view-more-icon.jpg'),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ],
                ))
          ]
        : [];
  }

  Widget getDocumentImage(String fileName) {
    int ext = 0;
    switch (extension(fileName)) {
      case '.docx':
        {
          ext = 0;
        }
        break;
      case '.doc':
        {
          ext = 0;
        }
        break;
      case '.ppt':
        {
          ext = 1;
        }
        break;
      case '.xlsx':
        {
          ext = 2;
        }
        break;
      default:
        ext = 3;
    }
    return Image.asset(
      iconList[ext],
      fit: BoxFit.contain,
    );
  }

  List<Widget> buildSDGRow() {
    return [
      Padding(
        padding: EdgeInsets.only(
            top: 1.5 * SizeConfig.heightMultiplier,
            right: 8.0 * SizeConfig.widthMultiplier,
            left: 8.0 * SizeConfig.widthMultiplier),
        child: Text(
          "RELATED SDGS",
          style: TextStyle(
              color: Colors.grey[600], fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      Container(
        padding: EdgeInsets.all(20),
        width: 100 * SizeConfig.widthMultiplier,
        // constraints: BoxConstraints(
        //     minHeight: SizeConfig.heightMultiplier * 10,
        //     maxHeight: SizeConfig.heightMultiplier * 30),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Tags(
              itemCount: project.sdgs.length, // required
              itemBuilder: (int index) {
                return ItemTags(
                  key: Key(index.toString()),
                  index: index, // required
                  title: project.sdgs[index].sdgName,
                  color: kScaffoldColor,
                  border: Border.all(color: Colors.grey[400]),
                  textColor: Colors.grey[600],
                  elevation: 0,
                  active: false,
                  pressEnabled: false,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                );
              },
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.start,
              spacing: 6,
              runSpacing: 6,
            ),
          ),
        ]),
      )
    ];
  }
}
