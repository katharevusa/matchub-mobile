import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
//import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/resourceVerticalCard.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ProfileResource extends StatefulWidget {
  Profile profile;

  ProfileResource(this.profile);

  @override
  _ProfileResourceState createState() => _ProfileResourceState();
}

class _ProfileResourceState extends State<ProfileResource> {
  List<Resources> listOfResources = [];
  Future listOfHostedResourcesFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;

  @override
  void initState() {
    listOfHostedResourcesFuture = retrieveResources();
    super.initState();
  }

  retrieveResources() async {
    // var profileId = Provider.of<Auth>(context).myProfile.accountId;
    final url =
        'authenticated/getHostedResources?profileId=${widget.profile.accountId}';
    final responseData = await _helper.getProtected(url,
        accessToken:
            Provider.of<Auth>(this.context, listen: false).accessToken);
    listOfResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // print(listOfResources.length.toString() + "========================");
    return FutureBuilder(
      future: listOfHostedResourcesFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Scaffold(
                  body: (listOfResources.isEmpty)
                      ? Center(
                          child: Text("No Resources Available",
                              style: AppTheme.titleLight))
                      : ListView.builder(
                          itemBuilder: (context, index) => ResourceVerticalCard(
                            resource: listOfResources[index],
                          ),
                          itemCount: listOfResources.length,
                        ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
