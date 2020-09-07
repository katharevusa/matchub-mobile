import 'package:flutter/material.dart';
import 'package:matchub_mobile/model/resource.dart';

class OwnResourceDetailScreen extends StatelessWidget {
  static const routeName = "/own-resource-detail";

  @override
  Widget build(BuildContext context) {
    final Resource resource = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(resource.title),
      ),
      body: SingleChildScrollView(
        child: Center(child: Text("Own Resource detail")),
      ),
    );
  }
}
