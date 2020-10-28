import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:share/share.dart';

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
    return FutureBuilder(
      future: resourceOwnerFuture,
      builder: (context, snapshot) =>
          (snapshot.connectionState == ConnectionState.done)
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  widget.resource.resourceDescription,
                                  style: TextStyle(
                                    height: 1.6,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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
                                        DateFormat('dd-MMM-yyyy ')
                                            .add_jm()
                                            .format(DateTime.parse(
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
                                        DateFormat('dd-MMM-yyyy ')
                                            .add_jm()
                                            .format(DateTime.parse(
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
}
