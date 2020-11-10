import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';

class ViewAllCampaignsScreen extends StatefulWidget {
  List<Campaign> fundCampaigns;
  ViewAllCampaignsScreen({this.fundCampaigns});
  @override
  _ViewAllCampaignsScreenState createState() => _ViewAllCampaignsScreenState();
}

class _ViewAllCampaignsScreenState extends State<ViewAllCampaignsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sdfs"),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return Container(
            height: 100,
            child: Text("sdfsf"),
          );
        },
        itemCount: widget.fundCampaigns.length,
      ),
    );
  }
}
