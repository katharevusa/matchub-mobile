import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_provider/country_provider.dart';
import 'package:flutter/material.dart';

import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';

class InfoEditPage extends StatefulWidget {
  final Map<String, dynamic> profile;

  PageController controller;

  InfoEditPage(this.profile, this.controller);
  @override
  _InfoEditPageState createState() => _InfoEditPageState();
}

class _InfoEditPageState extends State<InfoEditPage> {
  String countryCode;
  Future isLoaded;
  @override
  initState() {
    isLoaded =  getCountryCode();
  }

  getCountryCode() async {
      await CountryProvider.getCountryByFullname(widget.profile['country'])
          .then((value) => countryCode = value.callingCodes.first);
    print(countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
          future: isLoaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 3,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(
                                        color: Colors.grey[850], fontSize: 14),
                                    fillColor: Colors.grey[100],
                                    hoverColor: Colors.grey[100],
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kSecondaryColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[850],
                                      ),
                                    ),
                                  ),
                                  initialValue: widget.profile['firstName'],
                                  keyboardType: TextInputType.name,
                                  // validator: (value) {
                                  //   if (value.isEmpty || !value.contains('@')) {
                                  //     return 'Invalid email!';
                                  //   }
                                  // },
                                  onChanged: (value) {
                                    widget.profile['firstName'] = value;
                                  },
                                ),
                              ),
                              SizedBox(width: 1 * SizeConfig.widthMultiplier),
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                        color: Colors.grey[850], fontSize: 14),
                                    fillColor: Colors.grey[100],
                                    hoverColor: Colors.grey[100],
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kSecondaryColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[850],
                                      ),
                                    ),
                                  ),
                                  initialValue: widget.profile['lastName'],
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) {
                                    widget.profile['lastName'] = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText:
                                  'Fill in your profile\'s description here.',
                              labelStyle: TextStyle(
                                  color: Colors.grey[850], fontSize: 14),
                              fillColor: Colors.grey[100],
                              hoverColor: Colors.grey[100],
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kSecondaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[850],
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 8,
                            maxLines: 10,
                            maxLength: 500,
                            maxLengthEnforced: true,
                            initialValue: widget.profile['profileDescription'],
                            onChanged: (value) {
                              widget.profile['profileDescription'] = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone No.',
                              hintText: 'Fill in your phone no. here',
                              labelStyle: TextStyle(
                                  color: Colors.grey[850], fontSize: 14),
                              fillColor: Colors.grey[100],
                              hoverColor: Colors.grey[100],
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kSecondaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[850],
                                ),
                              ),
                            ),
                            initialValue: widget.profile['phoneNumber'],
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              widget.profile['phoneNumber'] = value;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(
                                  color: Colors.grey[850], fontSize: 14),
                              fillColor: Colors.grey[800],
                              hoverColor: Colors.grey[800],
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kSecondaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[850],
                                ),
                              ),
                            ),
                            initialValue: widget.profile['city'],
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              widget.profile['city'] = value;
                            },
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 7.5 * SizeConfig.heightMultiplier,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.grey[850]),
                                )),
                            child: CountryListPick(
                                isShowFlag: true,
                                isShowTitle: true,
                                isShowCode: true,
                                isDownIcon: true,
                                showEnglishName: true,
                                initialSelection: "+${countryCode}",
                                buttonColor: Colors.transparent,
                                // to get feedback data from picker
                                onChanged: (CountryCode code) {
                                  widget.profile['country'] = code.name;
                                }),
                          ),
                        ],
                      )));
            }
          }),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("1/2", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () => widget.controller.animateToPage(2,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 300)),
                child: Text("Next")),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
