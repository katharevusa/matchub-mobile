import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/models/review.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

import 'package:provider/provider.dart';

class ProfileReviews extends StatefulWidget {
  @override
  _ProfileReviewsState createState() => _ProfileReviewsState();
}

class _ProfileReviewsState extends State<ProfileReviews> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  List<Review> reviews = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Future reviewsFuture;
  @override
  void initState() {
    reviewsFuture = retrieveAllReviews();
    super.initState();
  }

  retrieveAllReviews() async {
    Profile profile = Provider.of<Auth>(this.context, listen: false).myProfile;
    final url =
        'authenticated/profilewall/reviewsReceived/${profile.accountId}';
    final responseData = await _apiHelper.getProtected(
        url,  accessToken:Provider.of<Auth>(this.context, listen: false).accessToken);
    reviews = (responseData['content'] as List)
        .map((e) => Review.fromJson(e))
        .toList();
    print(reviews.length);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: reviewsFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Scaffold(
                  backgroundColor: Color(0xfff0f0f0),
                  body: reviews.isNotEmpty
                      ? SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: reviews.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return OneReview(reviews[index]);
                                }),
                          ),
                        )
                      : Text("no reivew"),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }
}

class OneReview extends StatefulWidget {
  Review review;
  OneReview(this.review);
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<OneReview> {
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
        color: Colors.transparent,
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: ClipOval(
                      child: AttachmentImage(
                          widget.review.reviewer['profilePhoto']),
                    )),
                Text(
                  widget.review.reviewer['firstName'] +
                      widget.review.reviewer['lastName'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Project involved: " + widget.review.project['projectTitle'],
            ),
            SizedBox(height: 10),
            Text(
              widget.review.content,
            ),
            widget.review.rating == 5
                ? Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.red.shade200,
                        size: 18,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.red.shade200,
                        size: 18,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.red.shade200,
                        size: 18,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.red.shade200,
                        size: 18,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.red.shade200,
                        size: 18,
                      ),
                    ],
                  )
                : widget.review.rating == 1
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                        ],
                      )
          ],
        ),
      ),
    );
  }
}

/*   return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              image: DecorationImage(
                  image: NetworkImage(reviews[index]['userPhoto']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  reviews[index]['username'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Text(reviews[index]['content'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                reviews[index]["rating"] == 5
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                        ],
                      )
                    : reviews[index]["rating"] == 1
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                            ],
                          )
              ],
            ),
          )
        ],
      ),
    );*/
