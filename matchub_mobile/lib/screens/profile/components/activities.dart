import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/post.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:matchub_mobile/helpers/extensions.dart';

class Activities extends StatefulWidget {
  List<Post> listOfPosts;
  Profile profile;
  Activities(this.listOfPosts, this.profile);
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
                "${widget.listOfPosts[index].listOfComments.length} comments | ${widget.listOfPosts[index].likes} likes"),
            trailing: Text(
                DateTime.now().differenceFrom(
                  widget.listOfPosts[index].timeCreated,
                ),
                style: AppTheme.unSelectedTabLight),
          ),
          SizedBox(height: 10),
          Text("${widget.listOfPosts[index].content}",
              style: AppTheme.unSelectedTabLight),
          SizedBox(height: 10),
          ButtonBar(
            // alignment: MainAxisAlignment.spaceBetween,
            buttonTextTheme: ButtonTextTheme.primary,
            children: [
              FlatButton(
                visualDensity: VisualDensity.comfortable,
                highlightColor: Colors.transparent,
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      size: 13,
                      color: Provider.of<Auth>(context)
                                  .user
                                  .likedPosts
                                  .indexWhere((element) =>
                                      widget.profile.posts[index].postId ==
                                      element.postId) >=
                              0
                          ? kAccentColor
                          : Colors.grey,
                    ),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    Provider.of<Auth>(context)
                        .user
                        .toggleLikedPost(widget.profile.posts[index]);
                  });
                },
              ),
              FlatButton(
                  textColor: Colors.grey,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                        size: 13,
                      ),
                    ],
                  )),
              FlatButton(
                  textColor: Colors.grey,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.grey,
                        size: 13,
                      ),
                    ],
                  )),
              popUpMenu(widget.listOfPosts[index], context),
            ],
          )
        ],
      ),
      itemCount: widget.listOfPosts.length,
    );
  }

  Widget popUpMenu(Post currentPost, BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 2) {
            _deleteDialog(currentPost, context);
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                      ),
                      Text('Edit')
                    ],
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                      ),
                      Text('Delete')
                    ],
                  )),
              PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                      ),
                      Text('Share')
                    ],
                  )),
            ]);
  }

  _deletePost(Post post, BuildContext context) async {
    ApiBaseHelper _helper = ApiBaseHelper();
    var profileId = Provider.of<Auth>(context).myProfile.accountId;
    final url = 'authenticated/deletePost/${post.postId}/${profileId}';
    final responseData = await _helper.deleteProtected(url,
        accessToken: Provider.of<Auth>(context).accessToken);
  }

  _deleteDialog(Post post, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(right: 16.0),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      bottomLeft: Radius.circular(75),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                      image: AssetImage(
                        './././assets/images/info-icon.png',
                      ),
                    ))),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Alert!",
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(height: 10.0),
                        Flexible(
                          child: Text("Do you want to delete this comment?"),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                child: Text("No"),
                                color: Colors.red,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: RaisedButton(
                                child: Text("Yes"),
                                color: Colors.green,
                                colorBrightness: Brightness.dark,
                                onPressed: () {
                                  _deletePost(post, context);
                                  Navigator.pop(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
