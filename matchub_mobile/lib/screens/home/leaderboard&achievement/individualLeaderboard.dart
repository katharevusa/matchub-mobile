import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';

class IndividialLeaderboard extends StatefulWidget {
  @override
  _IndividialLeaderboardState createState() => _IndividialLeaderboardState();
}

class _IndividialLeaderboardState extends State<IndividialLeaderboard> {
  List<Profile> individuals = [];
  Future individualsFuture;
  ApiBaseHelper _helper = ApiBaseHelper.instance;
  @override
  void initState() {
    individualsFuture = getIndividuals();
    super.initState();
  }

  getIndividuals() async {
    final url = 'authenticated/individualLeaderboard';
    final responseData = await _helper.getProtected(
      url,
    );
    individuals = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: individualsFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              body: Column(
              children: [
                Stack(children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: AppTheme.selectedTabBackgroundColor,
                    ),
                    width: double.infinity,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 90, bottom: 20),
                    width: 299,
                    height: 279,
                    decoration: BoxDecoration(
                        color: AppTheme.project3,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(160),
                            bottomLeft: Radius.circular(290),
                            bottomRight: Radius.circular(160),
                            topRight: Radius.circular(10))),
                  ),
                ]),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                  itemBuilder: (context, index) => Material(
                      child: InkWell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 70,
                          color: AppTheme.project3.withOpacity(0.3),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  color: Colors.red,
                                  width: 70,
                                  height: 70,
                                  child: Center(
                                    child: Text(
                                      '#' + (index + 1).toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )),
                              SizedBox(width: 10),

                              Text(individuals[index].name,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              // Icon(Icons.arrow_forward_ios,
                              //     color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                  // ListTile(
                  //   onTap: () => Navigator.of(context).pushNamed(
                  //       ProfileScreen.routeName,
                  //       arguments: individuals[index].accountId),
                  //   leading: ClipOval(
                  //       child: Container(
                  //     height: 50,
                  //     width: 50,
                  //     child: AttachmentImage(individuals[index].profilePhoto),
                  //   )),
                  //   title: Text(individuals[index].name),
                  // ),
                  itemCount: individuals.length,
                ),
              ],
            ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class Sales {
  const Sales(this.season, this.iceCream);

  final String season;
  final int iceCream;
}

class SimpleBarChart extends StatelessWidget {
  // X value -> Y value
  static const myData = [
    const Sales(
      "3rd",
      40,
    ),
    const Sales(
      "2nd",
      50,
    ),
    const Sales("1st", 30),
  ];

  @override
  Widget build(BuildContext context) {
    final xAxis = new ChartAxis<String>(
      span: new ListSpan(myData.map((sales) => sales.season).toList()),
    );

    final yAxis = new ChartAxis<int>(
      span: new IntSpan(0, 75),
      tickGenerator: IntervalTickGenerator.byN(15),
    );

    final barStack1 = new BarStack<int>();

    return new AspectRatio(
      aspectRatio: 2.0,
      child: new BarChart<Sales, String, int>(
        data: myData,
        xAxis: xAxis,
        yAxis: yAxis,
        bars: [
          new Bar<Sales, String, int>(
            xFn: (sales) => sales.season,
            valueFn: (sales) => sales.iceCream,
            fill: new PaintOptions.fill(color: AppTheme.project6),
            stack: barStack1,
          ),
        ],
      ),
    );
  }
}
