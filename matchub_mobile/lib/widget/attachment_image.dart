import 'package:flutter/material.dart';

class AttachmentImage extends StatelessWidget {
  final String imageUrl;

  AttachmentImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ?
        // Image(
        //     image: NetworkImage(
        //     "http://192.168.72.136:8080/api/v1/images/$imageUrl"),
        //     fit: BoxFit.cover,
        //     loadingBuilder: (context, child, loadingProgress) {
        //       if (loadingProgress == null) return child;
        //       return Image.asset(
        //         "assets/images/loading.jpg",
        //         fit: BoxFit.contain,
        //       );
        //     },
        //     errorBuilder: (context, error, stackTrace) => Image.asset(
        //       "assets/images/loading.jpg",
        //       fit: BoxFit.cover,
        //     ),
        //   )
        Image(
            image: AssetImage(
              imageUrl,
            ),
            fit: BoxFit.cover,
          )
        : Image.asset(
            "assets/images/loading.jpg",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              "assets/images/loading.jpg",
              fit: BoxFit.cover,
            ),
          );
  }
}
