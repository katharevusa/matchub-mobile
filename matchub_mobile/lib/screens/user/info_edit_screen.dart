import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/sizeconfig.dart';

class InfoEditPage extends StatefulWidget {
  final Map<String, dynamic> profile;

  InfoEditPage(this.profile);
  @override
  _InfoEditPageState createState() => _InfoEditPageState();
}

class _InfoEditPageState extends State<InfoEditPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle:
                              TextStyle(color: Colors.grey[850], fontSize: 14),
                          fillColor: Colors.grey[100],
                          hoverColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[850]),
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
                          labelStyle:
                              TextStyle(color: Colors.grey[850], fontSize: 14),
                          fillColor: Colors.grey[100],
                          hoverColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[850]),
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
                    hintText: 'Fill in your profile\'s description here.',
                    labelStyle:
                        TextStyle(color: Colors.grey[850], fontSize: 14),
                    fillColor: Colors.grey[100],
                    hoverColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[850]),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
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
                    labelStyle:
                        TextStyle(color: Colors.grey[850], fontSize: 14),
                    fillColor: Colors.grey[100],
                    hoverColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[850]),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                  initialValue: widget.profile['phoneNo'],
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    widget.profile['phoneNo'] = value;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'City',
                          labelStyle:
                              TextStyle(color: Colors.grey[850], fontSize: 14),
                          fillColor: Colors.grey[100],
                          hoverColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[850]),
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
                    ),
                    CountryListPick(
                        isShowFlag: true,
                        isShowTitle: true,
                        isShowCode: true,
                        isDownIcon: true,
                        showEnglishName: true,
                        initialSelection: '+65',
                        buttonColor: Colors.transparent,
                        // to get feedback data from picker
                        onChanged: (CountryCode code) {
                          widget.profile['country'] = code.name;
                        }),
                  ],
                ),
              ],
            )));
  }
}
