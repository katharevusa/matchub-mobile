import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class OrganisationLeaderboard extends StatefulWidget {
  @override
  _OrganisationLeaderboardState createState() =>
      _OrganisationLeaderboardState();
}

class _OrganisationLeaderboardState extends State<OrganisationLeaderboard> {
  List<Profile> organisations = [];
  Future organisationsFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  @override
  void initState() {
    organisationsFuture = getOrganisations();
    super.initState();
  }

  getOrganisations() async {
    final url = 'authenticated/organisationalLeaderboard';
    final responseData = await _helper.getProtected(
      url,
    );
    organisations = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: organisationsFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              body: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                  itemBuilder: (context, index) => ListTile(
                    onTap: () => Navigator.of(context).pushNamed(
                        ProfileScreen.routeName,
                        arguments: organisations[index].accountId),
                    leading: ClipOval(
                        child: Container(
                      height: 50,
                      width: 50,
                      child: AttachmentImage(organisations[index].profilePhoto),
                    )),
                    title: Text(organisations[index].name),
                  ),
                  itemCount: organisations.length,
                ),
              ],
            ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
