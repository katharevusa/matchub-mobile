import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_resource.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/resourceVerticalCard.dart';
import 'package:provider/provider.dart';

class ViewSavedResources extends StatefulWidget {
  Profile profile;
  ViewSavedResources({this.profile});

  @override
  _ViewSavedResourcesState createState() => _ViewSavedResourcesState();
}

class _ViewSavedResourcesState extends State<ViewSavedResources> {
  List<Resources> listOfSavedResources = [];
  Future loadFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;

  // @override
  // void initState() {
  //   loadFuture = retrieveResources();
  //   super.initState();
  // }

  // retrieveResources() async {
  //   // var profileId = Provider.of<Auth>(context).myProfile.accountId;
  //   final url =
  //       'authenticated/getSavedResourcesByAccountId/${widget.profile.accountId}';
  //   final responseData = await _helper.getProtected(url,
  //       accessToken:
  //           Provider.of<Auth>(this.context, listen: false).accessToken);
  //   listOfSavedResources = (responseData['content'] as List)
  //       .map((e) => Resources.fromJson(e))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    listOfSavedResources =
        Provider.of<ManageResource>(this.context).savedResources;
    return
        // FutureBuilder(
        //   future: loadFuture,
        //   builder: (context, snapshot) =>
        //       (snapshot.connectionState == ConnectionState.done)
        //           ?
        Scaffold(
      appBar: (AppBar(
        title: Text("Saved Resources"),
      )),
      body: (listOfSavedResources.isEmpty)
          ? Center(
              child: Text("No Saved Resources", style: AppTheme.titleLight))
          : ListView.builder(
              itemBuilder: (context, index) => ResourceVerticalCard(
                resource: listOfSavedResources[index],
              ),
              itemCount: listOfSavedResources.length,
            ),
      // )
      // : Center(child: CircularProgressIndicator()),
    );
  }
}
