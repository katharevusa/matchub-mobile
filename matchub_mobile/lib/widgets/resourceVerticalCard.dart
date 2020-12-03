import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceDetail_screen.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class ResourceVerticalCard extends StatelessWidget {
  const ResourceVerticalCard({Key key, @required this.resource});

  final Resources resource;

  void selecteResource(BuildContext ctx, Resources individualResource) {
    Navigator.of(ctx, rootNavigator: true).pushNamed(
        ResourceDetailScreen.routeName,
        arguments: individualResource);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selecteResource(context, resource),
      child: Container(
        constraints:
            BoxConstraints(minHeight: 20 * SizeConfig.heightMultiplier),
        margin: EdgeInsets.symmetric(
            vertical: 2 * SizeConfig.heightMultiplier,
            horizontal: 2 * SizeConfig.heightMultiplier),
        padding: EdgeInsets.all(2 * SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // color: _randomColor
          //     .randomColor(
          //         colorBrightness: ColorBrightness.veryLight,
          //         colorHue: ColorHue.multiple(
          //             colorHues: [ColorHue.green, ColorHue.blue]),
          //         colorSaturation: ColorSaturation.lowSaturation)
          //     .withAlpha(50),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 3),
              blurRadius: 10,
              color: kSecondaryColor.withOpacity(0.1),
            ),
            BoxShadow(
              offset: Offset(-4, -3),
              blurRadius: 10,
              color: kSecondaryColor.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                    padding: EdgeInsets.all(1 * SizeConfig.heightMultiplier),
                    color: Colors.white,
                    width: 25 * SizeConfig.widthMultiplier,
                    height: 18 * SizeConfig.heightMultiplier,
                    child: resource.photos.isNotEmpty
                        ? AttachmentImage(resource.photos[0])
                        : Image.asset("assets/images/resource-default2.png",
                            fit: BoxFit.cover))),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 1 * SizeConfig.heightMultiplier),
                      child: Text(resource.resourceName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                          ))),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0.7 * SizeConfig.heightMultiplier,
                        left: 1 * SizeConfig.heightMultiplier),
                    child: Text(resource.resourceDescription,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            height: 1.6,
                            fontSize: 1.3 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[850])),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: 1 * SizeConfig.heightMultiplier,
                              left: 1 * SizeConfig.heightMultiplier),
                          child: Tags(
                              key: UniqueKey(),
                              itemCount: 1, // required
                              itemBuilder: (int idx) {
                                if (resource.available == false) {
                                  return ItemTags(
                                    index: idx, // required
                                    title: ("Busy"),
                                    textStyle: TextStyle(
                                      fontSize: 1.6 * SizeConfig.textMultiplier,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    activeColor: Colors.orange[200],
                                    combine: ItemTagsCombine.withTextBefore,
                                    active: true,
                                    pressEnabled: false,
                                    elevation: 2,
                                  );
                                } else {
                                  return ItemTags(
                                    index: idx, // required
                                    title: ("Available"),
                                    textStyle: TextStyle(
                                      fontSize: 1.6 * SizeConfig.textMultiplier,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    activeColor: Colors.orange[200],
                                    combine: ItemTagsCombine.withTextBefore,
                                    active: true,
                                    pressEnabled: false,
                                    elevation: 2,
                                  );
                                }
                              })),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
