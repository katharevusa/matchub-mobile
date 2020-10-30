import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/sizeconfig.dart';

class Keywords extends StatefulWidget {
  Map<String, dynamic> project;
  Keywords(this.project);

  @override
  _KeywordsState createState() => _KeywordsState();
}

class _KeywordsState extends State<Keywords> {
  GlobalKey<TagsState> _tagStateKey =
      GlobalKey<TagsState>(debugLabel: '_tagStateKey');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tags(
            textField: TagsTextField(
          textStyle: TextStyle(fontSize: 16),
          hintText: "Add a Keyword",
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
              if (!widget.project['relatedResources'].contains(str)) {
                widget.project['relatedResources'].add(str);
              }
            });
          },
        )),
        SizedBox(height: 10),
        Tags(
          key: _tagStateKey,
          itemCount: widget.project['relatedResources'].length, // required
          itemBuilder: (int index) {
            final item = widget.project['relatedResources'][index];

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
                    widget.project['relatedResources'].removeAt(index);
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
    );
  }
}
