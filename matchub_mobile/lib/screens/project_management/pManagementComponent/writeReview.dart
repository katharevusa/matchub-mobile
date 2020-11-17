import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class WriteReview extends StatefulWidget {
  static const routeName = "/write-review";

  Project project;
  TruncatedProfile receiver;
  WriteReview({
    this.receiver,
    this.project,
  });
  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  Review review;
  Map<String, dynamic> reviewMap;

  @override
  void initState() {
    if (review == null) {
      review = Review();
    }
    reviewMap = {
      'reviewId': review.reviewId,
      'timeCreated': review.timeCreated,
      'content': review.content ?? "",
      'rating': review.rating ?? 2.5,
      'reviewer': review.reviewer,
      'project': review.project,
      'reviewReceiver': review.reviewReceiver
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        elevation: 0,
        title:
            Text("Review Team Member", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 100,
            width: 100,
            child: ClipOval(
              child: SizedBox(
                  height: 16 * SizeConfig.heightMultiplier,
                  width: 16 * SizeConfig.widthMultiplier,
                  child: AttachmentImage(widget.receiver.profilePhoto)),
            ),
          ),
          Text(
            "Review for " + widget.receiver.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          Text(
            "Rating: ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          RatingBar.builder(
            initialRating: 2.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              reviewMap['rating'] = rating;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Review',
                hintText: 'Fill in your review here.',
                labelStyle: TextStyle(color: Colors.grey[850], fontSize: 14),
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
              keyboardType: TextInputType.multiline,
              minLines: 8,
              maxLines: 10,
              maxLength: 500,
              maxLengthEnforced: true,
              onChanged: (value) {
                reviewMap['content'] = value;
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () async {
                  await submitReview();
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }

  submitReview() async {
    reviewMap["reviewerId"] =
        Provider.of<Auth>(context, listen: false).myProfile.accountId;
    reviewMap['projectId'] = widget.project.projectId;
    reviewMap['reviewReceiverId'] = widget.receiver.accountId;
    final url = "authenticated/createReview";

    Navigator.of(context).pop(true);
    try {
      final response = await ApiBaseHelper.instance
          .postProtected(url, body: json.encode(reviewMap));
      print("Success");
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }
}
