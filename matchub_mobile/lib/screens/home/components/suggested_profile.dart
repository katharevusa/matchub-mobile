import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/feed.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class SuggestedProfile extends StatefulWidget {
  const SuggestedProfile({
    Key key,
  }) : super(key: key);

  @override
  _SuggestedProfileState createState() => _SuggestedProfileState();
}

class _SuggestedProfileState extends State<SuggestedProfile> {
  List<Profile> recommendedProfiles = [];
  Profile myProfile;

  @override
  Widget build(BuildContext context) {
    recommendedProfiles = Provider.of<Feed>(context).recommendedProfiles;
    myProfile = Provider.of<Auth>(context).myProfile;
    return Container(
      decoration: BoxDecoration(color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.blueGrey[200].withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1)
          ]),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
            child: Row(
              children: [
                Text("Add to your feed",
                    style: TextStyle(color: Colors.grey[850], fontSize: 16)),
                Material(
                  color: Colors.white,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.refresh_rounded, color: Colors.grey[700]),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => Divider(thickness: 2, height: 2),
            shrinkWrap: true,
            itemBuilder: (_, idx) => ListTile(
              leading: Container(
                  height: 50,
                  width: 50,
                  child:
                      AttachmentImage(recommendedProfiles[idx].profilePhoto)),
              title: Text(recommendedProfiles[idx].name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey[700])),
              subtitle: Text(
                  "${recommendedProfiles[idx].followers.length.toString()} followers",
                  style: AppTheme.subTitleLight),
              trailing: FlatButton(
                onPressed: () async {
                  if (!myProfile.following
                      .contains(recommendedProfiles[idx].accountId)) {
                    await ApiBaseHelper.instance.postProtected(
                        "authenticated/followProfile?followId=${recommendedProfiles[idx].accountId}&accountId=${myProfile.accountId}");
                    await Provider.of<Auth>(context, listen: false)
                        .retrieveUser();
                    await Provider.of<Feed>(context, listen: false)
                        .retrieveSuggestedProfiles(myProfile.accountId);
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      key: UniqueKey(),
                      content: Text(
                          "You've started following: ${recommendedProfiles[idx].name}"),
                      duration: Duration(seconds: 3),
                    ));
                  }
                  setState(() {});
                },
                child: Text(
                  "+ Follow",
                  style: AppTheme.buttonLight.copyWith(
                      color: myProfile.following
                              .contains(recommendedProfiles[idx].accountId)
                          ? Colors.grey[300]
                          : kPrimaryColor,
                      fontSize: 15),
                ),
              ),
            ),
            itemCount: recommendedProfiles.length,
          ),
        ],
      ),
    );
  }
}
