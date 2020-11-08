import 'package:flutter/material.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

Widget buildAvatar(profile, {double radius = 50, Color borderColor = Colors.white}) {
  return Container(
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey[400].withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3)),
        ],
        border: Border.all(color: borderColor, width: 3),
        shape: BoxShape.circle),
    height: radius,
    width: radius,
    child: ClipOval(child: AttachmentImage(profile.profilePhoto)),
  );
}
