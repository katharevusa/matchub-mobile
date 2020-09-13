import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
 
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:provider/provider.dart';

class InterestEditPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  Function updateProfile;
  PageController controller;

  InterestEditPage(this.profile, this.controller, this.updateProfile);
  @override
  _InterestEditPageState createState() => _InterestEditPageState();
}

class _InterestEditPageState extends State<InterestEditPage> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SDGPicker.routeName)
                                .then((value) {
                              setState(() => widget.profile['sdgIds'] = value);
                              print(widget.profile['sdgIds']);
                            });
                          },
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: 7.5 * SizeConfig.heightMultiplier),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.grey[850]),
                                )),
                            child: Center(
                                child: Column(
                              children: [
                                Text("Select your SDG(s)",
                                    style: AppTheme.titleLight),
                                if (widget.profile['sdgIds'] != null) ...[
                                  SizedBox(height: 5),
                                  Text(
                                    "${widget.profile['sdgIds'].length} SDG(s) chosen",
                                  )
                                ]
                              ],
                            )),
                          ),
                        ),
                        SizedBox(height: 20),
                        Tags(
                            textField: TagsTextField(
                          textStyle: TextStyle(fontSize: 16),
                          hintText: "Add an Area(s) of Expertise",
                          constraintSuggestion: false,
                          duplicates: false,
                          autofocus: false,
                          enabled: true,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 30,
                          width: SizeConfig.widthMultiplier * 100,
                          suggestions: [],
                          onSubmitted: (String str) {
                            setState(() {
                              if (!widget.profile['areasOfExpertise'].contains(str)) {
                                widget.profile['areasOfExpertise'].add(str);
                              }
                            });
                          },
                        )),
                        SizedBox(height: 10),
                        Tags(
                          key: _tagStateKey,
                          itemCount:
                              widget.profile['areasOfExpertise'].length, // required
                          itemBuilder: (int index) {
                            final item = widget.profile['areasOfExpertise'][index];

                            return ItemTags(
                              key: Key(index.toString()),
                              index: index, // required
                              title: item,
                              textStyle: TextStyle(
                                fontSize: 14,
                              ),
                              combine: ItemTagsCombine.withTextBefore,
                              removeButton: ItemTagsRemoveButton(
                                onRemoved: () {
                                  setState(() {
                                    widget.profile['areasOfExpertise'].removeAt(index);
                                  });
                                  return true;
                                },
                              ),
                              active: true,
                              pressEnabled: false,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ))),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("2/2", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () => widget.updateProfile(
                    Provider.of<Auth>(context).accessToken, context),
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
