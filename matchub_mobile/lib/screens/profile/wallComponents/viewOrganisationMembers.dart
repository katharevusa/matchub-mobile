import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profileScreen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ViewOrganisationMembersScreen extends StatefulWidget {
  static const routeName = "/view-organisation-members-screen";
  Profile user;
  ViewOrganisationMembersScreen({
    this.user,
  });
  @override
  _ViewOrganisationMembersScreenState createState() =>
      _ViewOrganisationMembersScreenState();
}

class _ViewOrganisationMembersScreenState
    extends State<ViewOrganisationMembersScreen> {
  Future organisationMembersFuture;

  ApiBaseHelper _helper = ApiBaseHelper.instance;
  List<Profile> members;
  Profile myProfile;
  List<Profile> newMembersList;
  @override
  void initState() {
    super.initState();
    organisationMembersFuture = getMembers();
  }

  getMembers() async {
    final url =
        'authenticated/organisation/viewMembers/${widget.user.accountId}';
    final responseData = await _helper.getProtected(
        url, accessToken: Provider.of<Auth>(context, listen: false).accessToken);
    members = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    newMembersList = List.from(members);
  }

  TextEditingController _textController = TextEditingController();

  onItemChanged(String value) {
    print(value);
    setState(() {
      newMembersList = members
          .where((element) =>
              element.name.toUpperCase().contains(value.toUpperCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.name}"),
      ),
      body: FutureBuilder(
        future: organisationMembersFuture,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                    body: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _textController,
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
                        onChanged: onItemChanged,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemBuilder: (context, index) => ListTile(
                        onTap: () => Navigator.of(context).pushNamed(
                            ProfileScreen.routeName,
                            arguments: newMembersList[index].accountId),
                        leading: ClipOval(
                            child: Container(
                          height: 50,
                          width: 50,
                          child: AttachmentImage(
                              newMembersList[index].profilePhoto),
                        )),
                        title: Text(newMembersList[index].name),
                      ),
                      itemCount: newMembersList.length,
                    ),
                  ],
                )),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
