import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ExploreProjects extends StatelessWidget {
  List<Project> allProjects = [];
  ApiBaseHelper _helper = ApiBaseHelper.instance;

  retrieveAllProjects(BuildContext context) async {
    final url = 'authenticated/getAllProjects';
    final responseData = await _helper.getProtected(
        url, accessToken: Provider.of<Auth>(context, listen: false).accessToken);
    allProjects = (responseData['content'] as List)
        .map((e) => Project.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: retrieveAllProjects(context),
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? Scaffold(
                  body: Column(
                  children: [
                    SizedBox(height: 20),
                    Text("Projects"),
                    SizedBox(height: 20),
                    buildProjectList(context, allProjects),
                  ],
                ))
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildProjectList(BuildContext context, List<Project> allProjects) {
    return Container(
      height: 500.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: allProjects.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
              child: InkWell(
            onTap: () => Navigator.of(
              context,
            ).pushNamed(ProjectDetailScreen.routeName,
                arguments: allProjects[index]),
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
                              child: allProjects[index].photos.isNotEmpty
                                  ? AttachmentImage(
                                      allProjects[index].photos[0],
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
                              Text(allProjects[index].projectTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(fontSize: 14.0))),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(allProjects[index].projCreatorId.toString(),
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
                        Text(
                            "Upvotes: " + allProjects[index].upvotes.toString(),
                            style: Theme.of(context).textTheme.title.merge(
                                TextStyle(fontSize: 10.0, color: Colors.red))),
                        IconButton(
                          icon: Icon(Icons.favorite_border),
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
