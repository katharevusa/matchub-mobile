import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/project/projectDetail/project_detail_overview.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ConnectedProject extends StatefulWidget {
  Resources resource;
  ConnectedProject(this.resource);
  @override
  _ConnectedProjectState createState() => _ConnectedProjectState();
}

class _ConnectedProjectState extends State<ConnectedProject> {
  ApiBaseHelper _helper = ApiBaseHelper.instance;

  Future loadFuture;
  Project project;

  @override
  void initState() {
    loadFuture = loading();

    super.initState();
  }

  loading() async {
    final responseData = await ApiBaseHelper.instance.getProtected(
        "authenticated/getProject?projectId=${widget.resource.matchedProjectId}",
        accessToken:
            Provider.of<Auth>(this.context, listen: false).accessToken);
    project = Project.fromJson(responseData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Matched projects",
                            style: Theme.of(context).textTheme.title,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.transparent,
                      height: 200.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(ProjectDetailScreen.routeName,
                                arguments: project);
                          },
                          child: Container(
                              width: 150.0,
                              height: 200.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Container(
                                              child: project
                                                          .projectProfilePic !=
                                                      null
                                                  ? AttachmentImage(
                                                      project.projectProfilePic)
                                                  : Image.asset(
                                                      "assets/images/resource-default2.png",
                                                      fit: BoxFit.cover)))),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(project.projectTitle,
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subhead
                                          .merge(TextStyle(
                                              color: Colors.grey.shade600)))
                                ],
                              )),
                        ),
                      ),
                    )
                  ]),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
