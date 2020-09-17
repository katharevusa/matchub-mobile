import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_provider/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:provider/provider.dart';

class InterestEditPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  PageController controller;

  InterestEditPage(this.profile, this.controller);
  @override
  _InterestEditPageState createState() => _InterestEditPageState();
}

class _InterestEditPageState extends State<InterestEditPage> {
  GlobalKey<TagsState> _tagStateKey =
      GlobalKey<TagsState>(debugLabel: '_tagStateKey');
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
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SDGPicker.routeName)
                                .then((value) {
                              setState(() {
                                if (value != null) {
                                  widget.profile['sdgIds'] = (value);
                                }
                                print(widget.profile['sdgIds']);
                              });
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
                                  ),
                                  SizedBox(height:5),
                                   GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                              // mainAxisSpacing: 10,
                                              // crossAxisSpacing: 10,
                                              childAspectRatio: 1,
                                              crossAxisCount: 3),
                                              itemCount: widget.profile['sdgIds'].length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            int i =(widget.profile['sdgIds'][index]);
                                            i++;
                                        return Container(
                                          // height:50,
                                          child: Image.asset(
                                              "assets/icons/goal$i.png"),
                                        );
                                      }),
                                ]
                              ],
                            )),
                          ),
                        ),
                                 
                        SizedBox(height: 20),
                        Tags(
                            textField: TagsTextField(
                          textStyle: TextStyle(fontSize: 16),
                          hintText: "Add a Skill",
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
                              if (!widget.profile['skillSet'].contains(str)) {
                                widget.profile['skillSet'].add(str);
                              }
                            });
                          },
                        )),
                        SizedBox(height: 10),
                        Tags(
                          key: _tagStateKey,
                          itemCount:
                              widget.profile['skillSet'].length, // required
                          itemBuilder: (int index) {
                            final item = widget.profile['skillSet'][index];

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
                                    widget.profile['skillSet'].removeAt(index);
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
              child: Text("2/3", style: TextStyle(color: Colors.grey)),
            ),
            RaisedButton(
                color: kSecondaryColor,
                onPressed: () => widget.controller.animateToPage(3,
                    curve: Curves.decelerate,
                    duration: Duration(milliseconds: 800)),
                child: Text("Next")),
          ],
        ),
      ),
    );
  }
}
