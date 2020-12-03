import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/home/components/share_post.dart';
import 'package:matchub_mobile/screens/home/components/view_post.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/popupmenubutton.dart' as popupmenu;
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PostCard extends StatefulWidget {
  PostCard({this.post, this.isRepost = false});
  Post post;
  bool isRepost;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLoading = false;
  Post originalPost;
  @override
  void initState() {
    if (widget.post.originalPostId != null) {
      isLoading = true;
      fetchOriginalPost();
    }
    super.initState();
  }

  fetchOriginalPost() async {
    try {
      originalPost = Post.fromJson(await ApiBaseHelper.instance
          .getProtected("authenticated/getPost/${widget.post.originalPostId}"));
    } catch (ex) {
      originalPost = null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool likedPost = widget.post.likedUsersId.contains(
        Provider.of<Auth>(context, listen: false).myProfile.accountId);
    return isLoading
        ? Container()
        : InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(
                MaterialPageRoute(
                  builder: (_) => ViewPost(post: widget.post),
                ),
              )
                  .then(
                (value) {
                  if (value != null && value) {
                  } else {
                    ApiBaseHelper.instance
                        .getProtected(
                            "authenticated/getPost/${widget.post.postId}")
                        .then(
                          (value) => setState(
                            () {
                              widget.post = Post.fromJson(value);
                            },
                          ),
                        );
                  }
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueGrey[200].withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    dense: true,
                    leading: ClipOval(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: AttachmentImage(
                              widget.post.postCreator.profilePhoto)),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.post.postCreator.name}",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey[850]),
                          ),
                        ),
                        if (originalPost != null && !widget.isRepost)
                          Text(
                            " shared a post",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.grey[700]),
                          ),
                      ],
                    ),
                    subtitle: Text(
                        DateTime.now().differenceFrom(
                          widget.post.timeCreated,
                        ),
                        style: AppTheme.subTitleLight),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.post.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          height: 1.3,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (!widget.isRepost && originalPost != null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: PostCard(
                        post: originalPost,
                        isRepost: true,
                      ),
                    ),
                  if (!widget.isRepost &&
                      originalPost == null &&
                      widget.post.originalPostId == 0)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300], width: 2),
                      ),
                      child: Center(
                        child: Text(
                          "This post has been deleted by its creator.",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  if (widget.post.photos.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 200.0,
                          child: Swiper(
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
                    ),
                  if (!widget.isRepost) ...[
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
                                    color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text(
                                  widget.post.listOfComments.length.toString(),
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
                                        size: 20, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text(
                                  widget.post.likes.toString(),
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
                                    size: 20, color: Colors.grey[600]),
                                SizedBox(width: 4),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SharePost(originalPost: widget.post),
                                    ),
                                  )
                                  .then((value) => ApiBaseHelper.instance
                                      .getProtected(
                                          "authenticated/getPost/${widget.post.postId}"))
                                  .then((value) =>
                                      widget.post = Post.fromJson(value));
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
  }
}
