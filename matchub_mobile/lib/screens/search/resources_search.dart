import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class ResourcesSearchCard extends StatefulWidget {
  Resources resource;
  ResourcesSearchCard({this.resource});
  @override
  _ResourcesSearchCardState createState() => _ResourcesSearchCardState();
}

class _ResourcesSearchCardState extends State<ResourcesSearchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100 * SizeConfig.widthMultiplier,
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 100 * SizeConfig.widthMultiplier,
                  height: 20 * SizeConfig.heightMultiplier,
                  child: widget.resource.photos.isNotEmpty
                      ? AttachmentImage(
                          widget.resource.photos[0],
                        )
                      : Image.asset("assets/images/resource-default2.png"),
                )),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.resource.resourceName,
                          style:
                              AppTheme.selectedTabLight.copyWith(fontSize: 14)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text("Available till: " +
                          DateFormat.yMMMd()
                              .format(DateTime.parse(widget.resource.endTime)), style: AppTheme.searchLight)
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(FlutterIcons.bookmark_fea),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ));
  }
}
