import 'package:flutter/material.dart';

class ProfileReviews extends StatelessWidget {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

  //retrieve a list of reviews
  final List<Map> reviews = [
    {
      "username": "Edgewick Scchol",
      "rating": 1,
      "content":
          "rg.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model element IndividualEntity.savedResourceIdsSEVERE [org.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model e",
      "userPhoto":
          "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
    },
    {
      "username": "Xaviers International",
      "rating": 5,
      "content":
          "rg.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model element IndividualEntity.savedResourceIdsSEVERE [org.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model e",
      "userPhoto":
          "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
    },
    {
      "username": "Kinder Garden",
      "rating": 1,
      "content":
          "rg.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model element IndividualEntity.savedResourceIdsSEVERE [org.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model e",
      "userPhoto":
          "https://cdn.pixabay.com/photo/2016/06/09/18/36/logo-1446293_960_720.png"
    },
    {
      "username": "WilingTon Cambridge",
      "rating": 1,
      "content":
          "rg.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model element IndividualEntity.savedResourceIdsSEVERE [org.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model e",
      "userPhoto":
          "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
    },
    {
      "username": "Fredik Panlon",
      "rating": 1,
      "content":
          "rg.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model element IndividualEntity.savedResourceIdsSEVERE [org.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model e",
      "userPhoto":
          "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
    },
    {
      "username": "Whitehouse International",
      "rating": 1,
      "content":
          "rg.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model element IndividualEntity.savedResourceIdsSEVERE [org.netbeans.modules.j2ee.jpa.verification.JPAProblemFinder]: Failed to resolve java model element for JPA merged model e",
      "userPhoto":
          "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff0f0f0),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: reviews.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildList(context, index);
                }),
          ),
        ));
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
          color: Colors.grey.shade300,
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 3, color: secondary),
                  image: DecorationImage(
                      image: NetworkImage(reviews[index]['userPhoto']),
                      fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      reviews[index]['username'],
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      reviews[index]['content'],
                    ),
                    const SizedBox(height: 10.0),
                    reviews[index]["rating"] == 5
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                            ],
                          )
                        : reviews[index]["rating"] == 1
                            ? Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.red.shade200,
                                    size: 18,
                                  ),
                                ],
                              )
                            : Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.red.shade200,
                                    size: 18,
                                  ),
                                ],
                              )
                  ],
                ),
              ),
            ],
          ),
        ));

    /*   return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: secondary),
              image: DecorationImage(
                  image: NetworkImage(reviews[index]['userPhoto']),
                  fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  reviews[index]['username'],
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Text(reviews[index]['content'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                reviews[index]["rating"] == 5
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.red.shade200,
                            size: 18,
                          ),
                        ],
                      )
                    : reviews[index]["rating"] == 1
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.red.shade200,
                                size: 18,
                              ),
                            ],
                          )
              ],
            ),
          )
        ],
      ),
    );*/
  }
}
