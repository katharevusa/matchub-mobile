import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/profile_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/chat/chatScreen.dart';
import 'package:matchub_mobile/screens/home/components/share_post.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/feed.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/popupmenubutton.dart' as popupmenu;
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewPost extends StatefulWidget {
  ViewPost({this.post});
  Post post;
  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  TextEditingController commentController = TextEditingController();
  Post post;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool likedPost = widget.post.likedUsersId.contains(
        Provider.of<Auth>(context, listen: false).myProfile.accountId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        actions: [
          popupmenu.PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_vert_rounded,
                size: 24,
                color: Colors.grey[700],
              ),
              itemBuilder: (BuildContext context) => [
                    popupmenu.PopupMenuItem(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () async {
                          Navigator.of(context).pop();
                          await ApiBaseHelper.instance.deleteProtected(
                              "authenticated/deletePost/${widget.post.postId}/${Provider.of<Auth>(context, listen: false).myProfile.accountId}");
                          Navigator.of(context).pop(true);
                        },
                        dense: true,
                        leading: Icon(FlutterIcons.trash_alt_faw5s),
                        title: Text(
                          "Delete Post",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8),
                        ),
                      ),
                    )
                  ]),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          dense: true,
                          leading: ClipOval(
                            child: Container(
                                height: 50,
                                width: 50,
                                child: AttachmentImage(
                                    widget.post.postCreator.profilePhoto)),
                          ),
                          title: Text(
                            "${widget.post.postCreator.name}",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[850]),
                          ),
                          subtitle: Text(
                              DateFormat("dd MMM 'at' kk:mm")
                                  .format(widget.post.timeCreated),
                              style: AppTheme.subTitleLight),
                        ),
                        if (widget.post.photos.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Container(
                              height: 250.0,
                              child: Swiper(
                                itemWidth: 300.0,
                                pagination: SwiperPagination(),
                                control: SwiperControl(
                                    iconNext: null, iconPrevious: null),
                                itemCount: widget.post.photos.length,
                                itemBuilder:
                                    (BuildContext context, int itemIndex) =>
                                        Container(
                                  width: 90 * SizeConfig.widthMultiplier,
                                  child: AttachmentImage(
                                      widget.post.photos[itemIndex]),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.post.content,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                                height: 1.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Divider(color: Colors.grey[400]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              FlatButton(
                                minWidth: 60,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                child: Row(
                                  children: [
                                    Icon(FlutterIcons.chat_outline_mco,
                                        color: Colors.grey[400]),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.post.listOfComments.length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () {},
                              ),
                              FlatButton(
                                minWidth: 60,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                child: Row(
                                  children: [
                                    likedPost
                                        ? Icon(FlutterIcons.thumbs_o_up_faw,
                                            size: 20, color: Color(0xFFEA4B88))
                                        : Icon(FlutterIcons.thumbs_o_up_faw,
                                            size: 20, color: Colors.grey[400]),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.post.likedUsersId.length
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    )
                                  ],
                                ),
                                onPressed: () async {
                                  int likerId =
                                      Provider.of<Auth>(context, listen: false)
                                          .myProfile
                                          .accountId;
                                  if (!likedPost) {
                                    setState(() {
                                      widget.post.likedUsersId.add(likerId);
                                      widget.post.likes++;
                                    });
                                    widget.post = Post.fromJson(
                                        await ApiBaseHelper.instance.putProtected(
                                            "authenticated/likeAPost?postId=${widget.post.postId}&likerId=$likerId"));
                                  } else {
                                    setState(() {
                                      widget.post.likedUsersId.remove(likerId);
                                      widget.post.likes--;
                                    });
                                    widget.post = Post.fromJson(
                                        await ApiBaseHelper.instance.putProtected(
                                            "authenticated/unLikeAPost?postId=${widget.post.postId}&likerId=$likerId"));
                                  }
                                },
                              ),
                              FlatButton(
                                minWidth: 50,
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                child: Row(
                                  children: [
                                    Icon(FlutterIcons.share_faw5s,
                                        size: 20, color: Colors.grey[400]),
                                    SizedBox(width: 4),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (_) => SharePost(
                                              originalPost: widget.post)));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.post.listOfComments.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Text("Comments",
                                    style: TextStyle(
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier,
                                        color: Colors.grey[850])),
                              ),
                              buildCommentSection(),
                              SizedBox(height: 100)
                            ])
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("No comment yet",
                                    style: TextStyle(
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier,
                                        color: Colors.grey[850])),
                                Container(
                                  height: 180,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/empty.gif",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey[200]))),
              margin: EdgeInsets.all(0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              alignment: Alignment.bottomCenter,
              width: SizeConfig.widthMultiplier * 100,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        controller: commentController,
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                            hintText: "Add a comment...",
                            hintStyle: TextStyle(color: Colors.grey[700]))),
                  ),
                  InkWell(
                    onTap: () => addCommentToPost(),
                    child: Container(
                      height: 50,
                      width: 30,
                      margin: EdgeInsets.only(
                        left: 12,
                      ),
                      child: Icon(
                        FlutterIcons.paper_plane_faw5s,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  refresh() {
    setState(() {});
  }

  addCommentToPost() async {
    if (commentController.text.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      widget.post = Post.fromJson(
        await ApiBaseHelper.instance.postProtected(
          "authenticated/addComment?postId=${widget.post.postId}",
          body: json.encode({
            "content": commentController.text.trim(),
            "accountId":
                Provider.of<Auth>(context, listen: false).myProfile.accountId
          }),
        ),
      );
      Provider.of<Feed>(context).retrievePosts(
          Provider.of<Auth>(context, listen: false).myProfile.accountId);
      setState(() {
        commentController.clear();
      });
    }
  }

  buildCommentSection() {
    return ListView.builder(
      reverse: true,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.post.listOfComments.length,
      itemBuilder: (_, idx) {
        return PostComment(
            post: widget.post,
            context: context,
            trigger: refresh,
            comment: widget.post.listOfComments[idx]);
      },
    );
  }
}

class PostComment extends StatefulWidget {
  PostComment({
    Key key,
    @required this.post,
    @required this.comment,
    @required this.context,
    @required this.trigger,
  }) : super(key: key);
  Post post;
  Comment comment;
  Function trigger;

  final BuildContext context;

  @override
  _PostCommentState createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  bool isLoading = true;
  Profile commenter;

  @override
  initState() {
    fetchCommenter();
  }

  fetchCommenter() async {
    var responseData = await ApiBaseHelper.instance
        .getProtected("authenticated/getAccount/${widget.comment.accountId}");
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAvatar(commenter, radius: 50),
                    SizedBox(width: 10),
                    ChatBubble(
                      clipper:
                          ChatBubbleClipper1(type: BubbleType.receiverBubble),
                      backGroundColor: Color(0xffE7E7ED),
                      margin: EdgeInsets.only(top: 20, right: 10),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(commenter.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12)),
                                ),
                                if (commenter.accountId ==
                                    Provider.of<Auth>(context, listen: false)
                                        .myProfile
                                        .accountId)
                                  popupmenu.PopupMenuButton(
                                      onCanceled: () => FocusManager
                                          .instance.primaryFocus
                                          .unfocus(), //VERY IMPORTANT,
                                      child: Icon(
                                        Icons.more_vert_rounded,
                                        size: 16,
                                        color: Colors.grey[700],
                                      ),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (BuildContext context) => [
                                            popupmenu.PopupMenuItem(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                dense: true,
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await ApiBaseHelper.instance
                                                      .deleteProtected(
                                                          "authenticated/deleteComment?commentId=${widget.comment.commentId}&postId=${widget.post.postId}&deletorId=${Provider.of<Auth>(context, listen: false).myProfile.accountId}");
                                                  widget.post.listOfComments
                                                      .removeWhere((element) =>
                                                          element.commentId ==
                                                          widget.comment
                                                              .commentId);
                                                  widget.trigger();
                                                  setState(() {
                                                    Provider.of<Feed>(context)
                                                        .retrievePosts(
                                                            Provider.of<Auth>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .myProfile
                                                                .accountId);
                                                  });
                                                },
                                                leading: Icon(
                                                  FlutterIcons.trash_alt_faw5s,
                                                ),
                                                title: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.8),
                                                ),
                                              ),
                                            )
                                          ]),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.comment.content,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80.0, vertical: 10),
                  child: Text(
                    DateTime.now().differenceFrom(
                      widget.comment.timeCreated,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
