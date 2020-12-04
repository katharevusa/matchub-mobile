import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/unused/individual.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class Wall extends StatefulWidget {
  Profile profile;

  Wall({this.profile});

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8 * SizeConfig.widthMultiplier),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Activity", style: AppTheme.titleLight),
        SizedBox(height: 10),
        ListView.separated(
          separatorBuilder: (ctx, index) => Divider(height: 40, thickness: 1),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(widget.profile.profilePhoto),
                ),
                title: Text("${widget.profile.lastName}"),
                subtitle: Text(
                    "${widget.profile.posts[index].comments.length} comments | ${widget.profile.posts[index].likes} likes"),
                trailing: Text(
                    DateTime.now().differenceFrom(
                      widget.profile.posts[index].timeCreated,
                    ),
                    style: AppTheme.unSelectedTabLight),
              ),
              SizedBox(height: 10),
              Text("${widget.profile.posts[index].content}",
                  style: AppTheme.unSelectedTabLight),
              SizedBox(height: 10),
              ButtonBar(
                // alignment: MainAxisAlignment.spaceBetween,
                buttonTextTheme: ButtonTextTheme.primary,
                children: [
                  // FlatButton(
                  //   visualDensity: VisualDensity.comfortable,
                  //   highlightColor: Colors.transparent,
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.thumb_up,
                  //         color: Provider.of<Auth>(context)
                  //                     .zzZ
                  //                     .likedPosts
                  //                     .indexWhere((element) =>
                  //                         widget.profile.posts[index].postId ==
                  //                         element.postId) >=
                  //                 0
                  //             ? kAccentColor
                  //             : Colors.grey,
                  //       ),
                  //       Text("  Like",
                  //           style: TextStyle(
                  //             fontSize: 15,
                  //             color: Provider.of<Auth>(context)
                  //                         .user
                  //                         .likedPosts
                  //                         .indexWhere((element) =>
                  //                             widget.profile.posts[index]
                  //                                 .postId ==
                  //                             element.postId) >=
                  //                     0
                  //                 ? kAccentColor
                  //                 : Colors.grey,
                  //           ))
                  //     ],
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       Provider.of<Auth>(context)
                  //           .user
                  //           .toggleLikedPost(widget.profile.posts[index]);
                  //     });
                  //   },
                  // ),
                  SizedBox(width: 20),
                  FlatButton(
                      textColor: Colors.grey,
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.comment, color: Colors.grey),
                          Text(
                            "  Comment",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )),
                  FlatButton(
                      textColor: Colors.grey,
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.share, color: Colors.grey),
                          Text("  Share",
                              style: TextStyle(
                                fontSize: 15,
                              )),
                        ],
                      )),
                ],
              )
            ],
          ),
          itemCount: widget.profile.posts.length,
        ),
        if (widget.profile.posts.isEmpty) Text("No Posts Yet"),
        SizedBox(height: 20)
      ]),
    );
  }
}
