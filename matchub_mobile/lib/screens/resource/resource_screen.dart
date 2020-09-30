import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/resource/expiredResource.dart';
// import 'package:matchub_mobile/screens/resource/navDrawer.dart';
import 'package:matchub_mobile/screens/resource/ongoingResource.dart';
import 'package:matchub_mobile/screens/resource/resourceDrawer.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:provider/provider.dart';

class ResourceScreen extends StatefulWidget {
  static const routeName = "/resource-screen";

  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen>
    with SingleTickerProviderStateMixin {
  List<Resources> listOfResources;
  Future resourcesFuture;
  Resources resources;
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resourcesFuture = retrieveResources();
  }

  retrieveResources() async {
    var profileId = Provider.of<Auth>(context).myProfile.accountId;
    final url = 'authenticated/getHostedResources?profileId=${profileId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    listOfResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
    //   print(listOfResources[0].resourceName);
  }

  void selectOwnResource(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/own-resource-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: resourcesFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    drawer: ResourceDrawer(),
                    appBar: AppBar(
                      iconTheme: IconThemeData(
                        color: Colors.black, //change your color here
                      ),
                      title: Text("Resource Overview"),
                      elevation: 0.0,
                      bottom: PreferredSize(
                        preferredSize:
                            Size.fromHeight(10 * SizeConfig.widthMultiplier),
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            tabs: [
                              Tab(text: "Ongoing"),
                              Tab(text: "Expired"),
                              Tab(text: "Saved"),
                            ],
                            labelColor: Color.fromRGBO(64, 133, 140, 0.8),
                            indicatorColor: Color.fromRGBO(64, 133, 140, 0.8),
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(children: [
                      Container(
                        child: OngoingResource(listOfResources),
                      ),
                      Container(
                        child: ExpiredResource(listOfResources),
                      ),
                      Container(
                        child: OngoingResource(listOfResources),
                      ),
                    ]),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
