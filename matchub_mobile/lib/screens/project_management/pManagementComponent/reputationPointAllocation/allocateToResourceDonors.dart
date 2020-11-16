import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/manage_project.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';
import 'package:spinner_input/spinner_input.dart';

class AllocateToResourceDonors extends StatefulWidget {
  Project project;
  PageController controller;
  Map<String, dynamic> addtionalPoints;
  Map<String, dynamic> pointsToMembers;
  AllocateToResourceDonors(this.project, this.controller, this.addtionalPoints,
      this.pointsToMembers);
  @override
  _AllocateToResourceDonorsState createState() =>
      _AllocateToResourceDonorsState();
}

class _AllocateToResourceDonorsState extends State<AllocateToResourceDonors> {
  Map<Resources, num> resourceAndDonorMap = new Map();
  List<Resources> matchedResources = [];
  List<num> donors = [];
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  Future loadResources;
  // Map<num, double> additionalPoints = new Map();
  num reputationPool;
  @override
  void initState() {
    loadResources = getMatchedResources();
    // reputationPool = widget.project.projectPoolPoints;
    super.initState();
  }

  getMatchedResources() async {
    matchedResources = [];
    final url =
        'authenticated/getMatchedResourcesByProjectId?projectId=${widget.project.projectId}';
    final responseData = await _apiHelper.getWODecode(url);
    (responseData as List)
        .forEach((e) => matchedResources.add(Resources.fromJson(e)));

    for (Resources r in matchedResources) {
      resourceAndDonorMap.putIfAbsent(r, () => r.resourceOwnerId);
      if (!donors.contains(r.resourceOwnerId)) {
        donors.add(r.resourceOwnerId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.project =
        Provider.of<ManageProject>(context, listen: false).managedProject;
    accumulateAdditionalPoints();
    return Scaffold(
      body: FutureBuilder(
        future: loadResources,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Reward additional point to resource donors",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListTile(
                    title:
                        Text("Reputation pool: " + reputationPool.toString()),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return DonorContribution(
                          donors[index],
                          resourceAndDonorMap,
                          widget.addtionalPoints,
                          widget.project,
                          accumulateAdditionalPoints);
                    },
                    itemCount: donors.length,
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("1/2", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () => widget.controller.animateToPage(1,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 500)),
                child: Text("Next")),
          ],
        ),
      ),
    );
  }

  void accumulateAdditionalPoints() {
    num total = 0;
    widget.addtionalPoints.forEach((k, v) {
      total += v;
    });
    widget.pointsToMembers.forEach((k, v) {
      total += v;
    });
    setState(() {
      reputationPool = widget.project.projectPoolPoints - total;
    });
    print(reputationPool);
  }
}

class DonorContribution extends StatefulWidget {
  Function accumulateAdditionalPoints;
  Map<String, dynamic> additionalPoints;
  num accountId;
  Map resourceAndDonorMap;
  Project project;
  DonorContribution(this.accountId, this.resourceAndDonorMap,
      this.additionalPoints, this.project, this.accumulateAdditionalPoints);
  @override
  _DonorContributionState createState() => _DonorContributionState();
}

class _DonorContributionState extends State<DonorContribution> {
  Future load;
  Profile resourceOwner;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;
  List<Resources> resourcesUnderOwner = [];
  double spinner = 0;
  @override
  void initState() {
    load = retrieveOwner();
    super.initState();
  }

  retrieveOwner() async {
    final url = 'authenticated/getAccount/${widget.accountId}';
    final responseData = await _apiHelper.getProtected(url);
    resourceOwner = Profile.fromJson(responseData);
    widget.resourceAndDonorMap.forEach((k, v) {
      if (v == widget.accountId) {
        resourcesUnderOwner.add(k);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? ExpansionTile(
              title: Text(
                resourceOwner.name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                child: SpinnerInput(
                  spinnerValue: widget.additionalPoints
                          .containsKey(resourceOwner.accountId.toString())
                      ? widget
                          .additionalPoints[resourceOwner.accountId.toString()]
                      : 0,
                  minValue: 0,
                  // maxValue: widget.project.projectPoolPoints -
                  //     accumulateAdditionalPoints(),
                  onChange: (newValue) {
                    setState(() {
                      spinner = newValue;
                      if (!widget.additionalPoints
                          .containsKey(resourceOwner.accountId.toString())) {
                        widget.additionalPoints.putIfAbsent(
                            resourceOwner.accountId.toString(), () => spinner);

                        setState(() {});
                      } else {
                        widget.additionalPoints.update(
                            resourceOwner.accountId.toString(),
                            (value) => spinner);
                        setState(() {});
                      }
                      print(widget.additionalPoints);
                      widget.accumulateAdditionalPoints();
                    });
                  },
                ),
              ),
              children: <Widget>[
                for (Resources r in resourcesUnderOwner) ...[DonationInfo(r)]
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class DonationInfo extends StatefulWidget {
  Resources r;
  DonationInfo(this.r);

  @override
  _DonationInfoState createState() => _DonationInfoState();
}

class _DonationInfoState extends State<DonationInfo> {
  Future load;
  List<ResourceRequest> rr;
  ApiBaseHelper _apiHelper = ApiBaseHelper.instance;

  @override
  void initState() {
    load = retrieveRR();
    super.initState();
  }

  retrieveRR() async {
    final url =
        'authenticated/getResourceRequestByResourceId?resourceId=${widget.r.resourceId}';
    final responseData = await _apiHelper.getProtected(url);
    rr = (responseData['content'] as List)
        .map((e) => ResourceRequest.fromJson(e))
        .toList();
    for (ResourceRequest request in rr) {
      if (request.status != "ACCEPTED") {
        rr.remove(request);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
              ? ListTile(
                  title: Text(rr[0].unitsRequired.toString() +
                      " set of " +
                      widget.r.resourceName))
              : Center(child: CircularProgressIndicator()),
    );
  }
}
