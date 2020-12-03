import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ExploreResources extends StatefulWidget {
  @override
  _ExploreResourcesState createState() => _ExploreResourcesState();
}

class _ExploreResourcesState extends State<ExploreResources> {
  List<Resources> allResources = [];
  Future allResourcesFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;

  @override
  void initState() {
    allResourcesFuture = retrieveAllResources();
    super.initState();
  }

  retrieveAllResources() async {
    final url = 'authenticated/getAllAvailableResources';
    final responseData = await _helper.getProtected(
        url, accessToken: Provider.of<Auth>(context, listen: false).accessToken);
    print("======================");
    print(responseData['first']);
    allResources = (responseData['content'] as List)
        .map((e) => Resources.fromJson(e))
        .toList();
    print(allResources.length.toString() + " =====================");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: allResourcesFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Scaffold(
                  body: Column(
                  children: [
                    SizedBox(height: 20),
                    Text("Resources"),
                    SizedBox(height: 20),
                    buildResourceList(context, allResources),
                  ],
                ))
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildResourceList(BuildContext context, List<Resources> allResources) {
    // print(allResources.length);
    return Container(
      height: 500.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: allResources.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
              child: InkWell(
            onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
                ResourceDetailScreen.routeName,
                arguments: allResources[index]),
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                width: 150.0,
                height: 200.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              width: 100 * SizeConfig.widthMultiplier,
                              height: 30 * SizeConfig.heightMultiplier,
                              child: allResources[index].photos.isNotEmpty
                                  ? AttachmentImage(
                                      allResources[index].photos[0],
                                    )
                                  : Image.asset(
                                      "assets/images/resource-default2.png"),
                            ))),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(allResources[index].resourceName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(fontSize: 14.0))),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                  allResources[index]
                                      .resourceOwnerId
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subhead
                                      .merge(TextStyle(fontSize: 12.0))),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                )),
          ));
        },
      ),
    );
  }
}
