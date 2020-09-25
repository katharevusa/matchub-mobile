import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/database.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ChannelCreation extends StatefulWidget {
  Project project;
  ChannelCreation({this.project});
  @override
  _ChannelCreationState createState() => _ChannelCreationState();
}

class _ChannelCreationState extends State<ChannelCreation> {
  List<TruncatedProfile> contributors;
  List<TruncatedProfile> filteredContributors;
  PageController controller = PageController(initialPage: 0, keepPage: true);
  Map<String, dynamic> channelMap = {
    "name": null,
    "description": null,
    "createdAt": null,
    "createdBy": null,
    "projectId": null,
    "members": [],
    "admins": [],
  };

  @override
  void initState() {
    contributors = widget.project.teamMembers;
    filteredContributors = contributors;
    channelMap['projectId'] = "${widget.project.projectId}";
    channelMap['createdBy'] =
        Provider.of<Auth>(context, listen: false).myProfile.uuid;
    channelMap['admins']
        .add(Provider.of<Auth>(context, listen: false).myProfile.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              color: Colors.grey[850],
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text("Create a New Channel",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white)),
        ),
        // backgroundColor: kScaffoldColor,
        elevation: 10,
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[
          SelectMembers(
              contributors: contributors,
              filteredContributors: filteredContributors,
              channelMap: channelMap),
          InfoPage(channelMap: channelMap),
        ],
      ),
    );
  }
}

class SelectMembers extends StatefulWidget {
  SelectMembers({
    Key key,
    @required this.contributors,
    @required this.filteredContributors,
    @required this.channelMap,
  }) : super(key: key);

  final List<TruncatedProfile> contributors;
  List<TruncatedProfile> filteredContributors;
  Map<String, dynamic> channelMap;

  @override
  _SelectMembersState createState() => _SelectMembersState();
}

class _SelectMembersState extends State<SelectMembers> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
              expands: false,
              decoration: InputDecoration(
                hintText: "Search Profile...",
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  widget.filteredContributors = widget.contributors
                      .where((element) => element.name
                          .toUpperCase()
                          .contains(value.toUpperCase()))
                      .toList();
                });
              }),
        ),SizedBox(height:10),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 5),
          itemBuilder: (context, index) {
            return CheckboxListTile(
              secondary: ClipOval(
                  child: Container(
                height: 50,
                width: 50,
                child: AttachmentImage(
                    widget.filteredContributors[index].profilePhoto),
              )),
              title: Text(widget.filteredContributors[index].name),
              controlAffinity: ListTileControlAffinity.trailing,
              value: widget.channelMap['members']
                  .contains(widget.filteredContributors[index].uuid),
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked) {
                    widget.channelMap['members']
                        .add(widget.filteredContributors[index].uuid);
                  } else {
                    widget.channelMap['members']
                        .remove(widget.filteredContributors[index].uuid);
                  }
                  print(widget.channelMap['members']);
                });
              },
            );
          },
          itemCount: widget.filteredContributors.length,
        ),
      ]),
    );
  }
}

class InfoPage extends StatelessWidget {
  InfoPage({
    Key key,
    @required this.channelMap,
  }) : super(key: key);

  final Map<String, dynamic> channelMap;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Channel Name',
                  hintText: 'Fill in your channel\'s name here.',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 0.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 0.5),
                  ),enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[850],
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                initialValue: channelMap['name'],
                onChanged: (value) {
                  channelMap['name'] = value;
                },
                autovalidateMode: AutovalidateMode.always,
                validator: (newName) {
                  if (newName.isEmpty) {
                    return "Please enter a channel name";
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Fill in your channel\'s description here.',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 14),
                  fillColor: Colors.grey[100],
                  hoverColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
                  ),
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
                maxLength: 200,
                maxLengthEnforced: true,
                initialValue: channelMap['description'],
                onChanged: (value) {
                  channelMap['description'] = value;
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  color: kAccentColor,
                  onPressed: () async {
                    channelMap['createdAt'] = DateTime.now();
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    await DatabaseMethods().createChannel(channelMap);
                    Navigator.pop(context);
                  },
                  child: Text("Create Channel",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
