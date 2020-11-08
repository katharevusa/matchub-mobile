// import 'package:flutter/material.dart';
// import 'package:matchub_mobile/models/index.dart';
// import 'package:matchub_mobile/sizeconfig.dart';
// import 'package:matchub_mobile/widgets/attachment_image.dart';

// class ProfileCard extends StatelessWidget {
//   Profile profile;
//   ProfileCard(this.profile);

//   BoxDecoration _buildShadowAndRoundedCorners() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20.0),
//       boxShadow: <BoxShadow>[
//         BoxShadow(
//           spreadRadius: 2.0,
//           blurRadius: 10.0,
//           color: Colors.black26,
//         ),
//       ],
//     );
//   }

//   Widget _buildAvatar() {
//     return ClipRRect(
//         borderRadius: BorderRadius.circular(8.0),
//         child: Container(
//           width: 80.0,
//           height: 80.0,
//           padding: const EdgeInsets.all(3.0),
//           child: ClipOval(
//             clipper: MyClip(),
//             child: Container(child: AttachmentImage(profile.profilePhoto)),
//           ),
//         ));
//   }

//   Widget _buildInfo() {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Text(
//         profile.name,
//         overflow: TextOverflow.ellipsis,
//         maxLines: 2,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 1.5 * SizeConfig.textMultiplier,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 130.0,
//       padding: const EdgeInsets.all(8.0),
//       margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
//       decoration: _buildShadowAndRoundedCorners(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           _buildAvatar(),
//           _buildInfo(),
//         ],
//       ),
//     );
//   }
// }

// class MyClip extends CustomClipper<Rect> {
//   Rect getClip(Size size) {
//     return Rect.fromLTWH(0, 0, 80, 80);
//   }

//   bool shouldReclip(oldClipper) {
//     return false;
//   }
// }
