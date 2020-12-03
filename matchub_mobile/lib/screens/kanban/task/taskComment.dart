import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/profile_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/chatScreen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanban_controller.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class TaskCommentCard extends StatefulWidget {
  TaskEntity task;
  Comment comment;

  TaskCommentCard({this.comment, this.task});
  @override
  _TaskCommentCardState createState() => _TaskCommentCardState();
}

class _TaskCommentCardState extends State<TaskCommentCard> {
  Profile commenter;
  bool isLoading;

  @override
  void initState() {
    isLoading = true;
    getCommenter();
    super.initState();
  }

  getCommenter() async {
    var responseData = await ApiBaseHelper.instance.getProtected(
        "authenticated/getAccount/${widget.comment.accountId}",
        accessToken: Provider.of<Auth>(context, listen: false).accessToken);
    commenter = Profile.fromJson(responseData);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ChatListLoader(),
              period: Duration(milliseconds: 800),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: buildAvatar(
                    commenter,
                  ),
                  title: Text(commenter.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                  subtitle: Text(
                      DateFormat('dd MMM yyyy, kk:mm')
                          .format(widget.comment.timeCreated),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      )),
                  trailing: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      offset: Offset(0, 20),
                      icon: Icon(Icons.more_vert_rounded),
                      itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                visualDensity: VisualDensity.compact,
                                onTap: () {
                                  Clipboard.setData(
                                    new ClipboardData(
                                        text: widget.comment.content),
                                  );
                                  Toast.show("Copied to clipboard", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
                                  FocusManager.instance.primaryFocus
                                      .unfocus(); //VERY IMPORTANT
                                  // Navigator.pop(context);
                                },
                                dense: true,
                                leading: Icon(Icons.copy_rounded),
                                title: Text(
                                  "Copy",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.8),
                                ),
                              ),
                            ),
                            if (widget.comment.accountId ==
                                Provider.of<Auth>(context, listen: false)
                                    .myProfile
                                    .accountId)
                              PopupMenuItem(
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  visualDensity: VisualDensity.compact,
                                  onTap: () async {
                                  FocusManager.instance.primaryFocus
                                      .unfocus(); //VERY IMPORTANT
                                    await Provider.of<KanbanController>(context,
                                            listen: false)
                                        .deleteComment(
                                            widget.task, widget.comment);
                                    Navigator.pop(context);
                                  },
                                  dense: true,
                                  leading: Icon(FlutterIcons.trash_alt_faw5s),
                                  title: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8),
                                  ),
                                ),
                              )
                          ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: ReadMoreText(
                    widget.comment.content,
                    trimLines: 3,
                    style: TextStyle(
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                    colorClickableText: kSecondaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '...Show more',
                    trimExpandedText: '\nshow less',
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          );
  }
}
