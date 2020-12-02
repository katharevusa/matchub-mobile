import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_resource.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

class ResourceInformation extends StatefulWidget {
  Resources resource;
  ResourceInformation(this.resource);
  @override
  _ResourceInformationState createState() => _ResourceInformationState();
}

class _ResourceInformationState extends State<ResourceInformation> {
  Profile resourceOwner;
  ResourceCategory category;
  Future categoryFuture;
  Future resourceOwnerFuture;
  Profile myProfile;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  void initState() {
    super.initState();
    resourceOwnerFuture = getResourceOwner();
  }

  getResourceOwner() async {
    final url = 'authenticated/getAccount/${widget.resource.resourceOwnerId}';
    final responseData = await _helper.getProtected(url);
    resourceOwner = Profile.fromJson(responseData);
    await getCategoryById();
  }

  getCategoryById() async {
    final url =
        'authenticated/getResourceCategoryById?resourceCategoryId=${widget.resource.resourceCategoryId}';
    final responseData = await _helper.getProtected(url);
    category = ResourceCategory.fromJson(responseData);
    // print(category.resourceCategoryName);
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context).myProfile;
    return FutureBuilder(
      future: resourceOwnerFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(ProfileScreen.routeName,
                              arguments: widget.resource.resourceOwnerId);
                        },
                        leading: ClipOval(
                            child: Container(
                                color: Colors.white,
                                height: 16 * SizeConfig.widthMultiplier,
                                width: 16 * SizeConfig.widthMultiplier,
                                child: AttachmentImage(
                                    resourceOwner.profilePhoto))),
                        title: Text(
                          resourceOwner.name,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text("Resource creator"),
                        trailing: IconButton(
                          icon: Icon(FlutterIcons.share_google_evi),
                          onPressed: () {
                            Share.share(
                                'Hey there! Ever heard of the United Nation\'s Sustainable Development Goals?\nCheck out this resource on: ${widget.resource.resourceName}\n');
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 6,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.resource.resourceName,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            !widget.resource.spotlight &&
                                    (widget.resource.resourceOwnerId ==
                                        myProfile.accountId)
                                ? InkWell(
                                    onTap: () {
                                      spotlightAction(widget.resource, context);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star_border,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Spotlight",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : widget.resource.spotlight
                                    ? InkWell(
                                        onTap: () {
                                          spotlightDuration(
                                              widget.resource, context);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: AppTheme.project1,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Under Spotlight",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                            Text(
                              widget.resource.resourceDescription,
                              style: TextStyle(
                                height: 1.6,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            widget.resource.country != null
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppTheme.project5,
                                      ),
                                      Text(widget.resource.country,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey)),
                                    ],
                                  )
                                : Container(),
                            Text(
                                'Resource category: ' +
                                    category.resourceCategoryName,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey)),
                            Text(
                                'Amount: ${widget.resource.units} ' +
                                    category.unitName,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey)),
                            widget.resource.startTime != null
                                ? Text(
                                    DateFormat('dd-MMM-yyyy ').add_jm().format(
                                        DateTime.parse(
                                            widget.resource.startTime)),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey))
                                : Text("Not listed",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey)),
                            widget.resource.endTime != null
                                ? Text(
                                    DateFormat('dd-MMM-yyyy ').add_jm().format(
                                        DateTime.parse(
                                            widget.resource.endTime)),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey))
                                : Text("Not listed",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey)),
                            widget.resource.resourceType == "FREE"
                                ? Text("This is a free resource",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey))
                                : Text(
                                    "Price: \$" +
                                        widget.resource.price.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey)),
                            widget.resource.available
                                ? Text("Available",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green))
                                : Text("Unavailable",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  spotlightAction(Resources resource, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(15),
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                        "Spotlight your resource so that your project will appear on the featured resources on explore.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  // myProfile.spotlightChances != 0
                  // ?

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FlatButton(
                            color: AppTheme.project3,
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Spotlight resource",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                            onPressed: () async {
                              await spotlightResource();
                              Navigator.pop(context, true);
                            },
                          ),
                          Text(
                            '${myProfile.spotlightChances} ' + "chances left.",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                          image: AssetImage(
                            './././assets/images/spotlight.png',
                          ),
                        ))),
                      ),
                    ],
                  ),

                  // : Text("You do not have any spotlight chances.")
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  spotlightResource() async {
    final url =
        "authenticated/spotlightResource/${widget.resource.resourceId}/${myProfile.accountId}";
    try {
      final response = await ApiBaseHelper.instance.putProtected(
        url,
      );
      Provider.of<ManageResource>(context, listen: false)
          .getResourceById(widget.resource.resourceId);
      print("Success");
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), this.context);
    }
  }

  spotlightDuration(Resources resource, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(15),
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text("Spotlight will end in",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  SlideCountdownClock(
                    duration: Duration(
                        days: DateTime.parse(widget.resource.spotlightEndTime)
                            .difference(DateTime.now())
                            .inDays,
                        minutes:
                            DateTime.parse(widget.resource.spotlightEndTime)
                                .difference(DateTime.now())
                                .inMinutes),
                    slideDirection: SlideDirection.Up,
                    separator: ":",
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shouldShowDays: true,
                    onDone: () {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Spotlight has ended')));
                    },
                  ),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                      image: AssetImage(
                        './././assets/images/spotlight.png',
                      ),
                    ))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
