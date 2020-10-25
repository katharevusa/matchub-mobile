import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

import '../../../sizeconfig.dart';

class PCarousel extends StatelessWidget {
  Project project;
  PCarousel(this.project);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: project.projectProfilePic,
      child: CarouselSlider(
        options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 1.8,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false),
        items: (project.photos.isNotEmpty)
            ? getPhotoList(project.photos)
            : getPhotoList(imgList),
      ),
    );
  }

  List<Widget> getPhotoList(photos) {
    List<Widget> finalList = [];
    photos.forEach((item) {
      finalList.add(Container(
        // margin: EdgeInsets.symmetric(
        //     horizontal: SizeConfig.widthMultiplier * 8,
        //     vertical: SizeConfig.heightMultiplier * 2),
        child: Material(
          elevation: 1 * SizeConfig.heightMultiplier,
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              child: Stack(
                children: <Widget>[
                  Container(
                      width: 100 * SizeConfig.widthMultiplier,
                      child: AttachmentImage(item)),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Text(
                        // 'No. ${imgList.indexOf(item)} image',
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ));
    });
    return finalList;
  }
}

final List<String> imgList = [
  "https://localhost:8443/api/v1/files/init/project-default.jpg",
  // "https://localhost:8443/api/v1/files/init/project3.jpg",
  // "https://localhost:8443/api/v1/files/init/project6.jpg",
];
