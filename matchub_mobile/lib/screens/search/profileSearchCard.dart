import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/screens/profile/viewProfile.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class ProfileVerticalCard extends StatelessWidget {
  const ProfileVerticalCard({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(ViewProfile.routeName, arguments: profile.accountId);
      },
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300], width: 1.5),
                    shape: BoxShape.circle),
                height: 60,
                width: 60,
                child: ClipOval(child: AttachmentImage(profile.profilePhoto)),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: SizeConfig.widthMultiplier * 73),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              children: [
                                TextSpan(
                                  text: profile.name,
                                ),
                                if (profile.isOrganisation) ...[
                                  WidgetSpan(child: SizedBox(width: 2)),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.top,
                                    child: Icon(
                                      FlutterIcons.check_circle_faw5s,
                                      color: kSecondaryColor,
                                      size: 13,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Colors.grey[400],
                      size: 12,
                    ),
                    SizedBox(width: 2),
                    if (profile.city.isNotEmpty)
                      Text(
                        "${profile.city}, ",
                        style: AppTheme.searchLight,
                      ),
                    Text(
                      "${profile.country}",
                      style: AppTheme.searchLight,
                    )
                  ]),
                  SizedBox(height: 5),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: profile.reputationPoints.toString(),
                        style: AppTheme.selectedTabLight),
                    TextSpan(
                        text: " reputation ⚬ ", style: AppTheme.searchLight),
                    TextSpan(
                        text: profile.followers.length.toString(),
                        style: AppTheme.selectedTabLight),
                    TextSpan(text: " followers", style: AppTheme.searchLight),
                  ]))
                ],
              )
            ],
          )),
    );
  }
}
