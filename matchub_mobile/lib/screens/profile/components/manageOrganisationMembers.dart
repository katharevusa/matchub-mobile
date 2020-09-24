import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ManageOrganisationMembersScreen extends StatefulWidget {
  static const routeName = "/manage-organisation-members-screen";
  Profile user;
  ManageOrganisationMembersScreen({this.user});
  @override
  _ManageOrganisationMembersScreenState createState() =>
      _ManageOrganisationMembersScreenState();
}

class _ManageOrganisationMembersScreenState
    extends State<ManageOrganisationMembersScreen>
    with TickerProviderStateMixin {
  Future organisationMembersFuture;

  List<Profile> members;
  Profile myProfile;
  String searchQuery = "";
  List<Profile> filteredMembers;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void dismissSnackBar() {
    _scaffoldKey.currentState.removeCurrentSnackBar();
  }

  @override
  void initState() {
    super.initState();
    filteredMembers = members;
  }

  getMembers() async {}

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
                              filteredMembers = members
                                  .where((element) => element.name
                                      .toUpperCase()
                                      .contains(value.toUpperCase()))
                                  .toList();
                            });
                          }),
                    ),
                    SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemBuilder: (context, index) => ListTile(
                        onTap: () => Navigator.of(context).pushNamed(
                            ProfileScreen.routeName,
                            arguments: filteredMembers[index].accountId),
                        leading: ClipOval(
                            child: Container(
                          height: 50,
                          width: 50,
                          child: AttachmentImage(
                              filteredMembers[index].profilePhoto),
                        )),
                        title: Text(filteredMembers[index].name),
                      ),
                      itemCount: filteredMembers.length,
                    ),
                  ],
                )),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // Widget membersList() {
  //   return Column(
  //     children: [
  //       SizedBox(height: 10),
  //       ListView.separated(
  //         shrinkWrap: true,
  //         separatorBuilder: (context, index) => SizedBox(height: 5),
  //         itemBuilder: (context, index) => ListTile(
  //           leading: CircleAvatar(
  //             radius: 25,
  //             backgroundImage: AssetImage(members[index].profilePhoto),
  //           ),
  //           title: Text(members[index].name),
  //         ),
  //         itemCount: members.length,
  //       ),
  //     ],
  //   );
  // }
}
