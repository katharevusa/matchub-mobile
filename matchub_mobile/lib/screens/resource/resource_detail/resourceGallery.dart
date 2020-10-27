import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class RGallery extends StatelessWidget {
  CarouselController c = CarouselController();
  Resources resource;
  RGallery(this.resource);
  @override
  Widget build(BuildContext context) {
    List<String> imageLinks;
    if (resource.photos.isEmpty) {
      imageLinks = [
        'https://localhost:8443/api/v1/files/init/resource_default.jpg'
      ];
    } else {
      imageLinks = resource.photos.cast<String>().toList();
    }
    print(imageLinks);
    return CarouselSlider(
      key: UniqueKey(),
      options: CarouselOptions(
          enableInfiniteScroll: false,
          autoPlay: false,
          aspectRatio: 1.8,
          viewportFraction: 1.0,
          enlargeCenterPage: true),
      items: imageLinks
          .map((item) => Container(
                decoration: BoxDecoration(boxShadow: []),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 6,
                    vertical: SizeConfig.heightMultiplier * 2),
                child: Material(
                  elevation: 1 * SizeConfig.heightMultiplier,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 100 * SizeConfig.widthMultiplier,
                            child: AttachmentImage(item),
                          ),
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
              ))
          .toList(),
    );
  }
}
