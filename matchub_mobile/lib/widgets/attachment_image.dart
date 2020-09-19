import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';

class AttachmentImage extends StatelessWidget {
  final String imageUrl;

  AttachmentImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    // print("https://192.168.1.55:8443/api/v1/${imageUrl.substring(30)}");
    return (imageUrl != null && imageUrl.isNotEmpty)
        ? Image(
            image: NetworkImage(
                "${ApiBaseHelper().baseUrl}${imageUrl.substring(30)}"),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              "assets/images/avatar.png",
              fit: BoxFit.cover,
            ),
            // loadingBuilder: (context, child, loadingProgress) {
            //   if (loadingProgress == null) return child;
            //   return Image.asset(
            //     "assets/images/loading.jpg",
            //     fit: BoxFit.contain,
            //   );
            // },
            // errorBuilder: (context, error, stackTrace) => Image.asset(
            //   "assets/images/loading.jpg",
            //   fit: BoxFit.cover,
            // ),
          )
        // Image(
        //     image: AssetImage(
        //       imageUrl,
        //     ),
        //     fit: BoxFit.cover,
        //   )
        : Image.asset(
            "assets/images/avatar.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              "assets/images/avatar.png",
              fit: BoxFit.cover,
            ),
          );
  }
}
