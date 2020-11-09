import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/manage_organisationmembers.dart';
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
    extends State<ManageOrganisationMembersScreen> {
  Future organisationMembersFuture;

  ApiBaseHelper _helper = ApiBaseHelper.instance;
  List<Profile> members = [];
  Profile myProfile;
  List<Profile> searchResult = [];
  bool _isLoading;

  // @override
  // void initState() {
  //   super.initState();
  //   organisationMembersFuture = getMembers();
  // }
  @override
  void initState() {
    _isLoading = true;
    loadMembers();
    getMembers();
    super.initState();
  }

  loadMembers() async {
    Profile profile = Provider.of<Auth>(context, listen: false).myProfile;
    await Provider.of<ManageOrganisationMembers>(context, listen: false)
        .getMembers(profile);

    setState(() {
      _isLoading = false;
    });
    // await getList();
  }

  getMembers() async {
    final url =
        'authenticated/organisation/viewMembers/${widget.user.accountId}';
    final responseData = await _helper.getProtected(
        url,  accessToken:Provider.of<Auth>(context, listen: false).accessToken);
    members = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    searchResult = members;
  }

  getList() {
    members = Provider.of<ManageOrganisationMembers>(context).members;
  }

  getSearchedUsers(String value) async {
    final url = 'authenticated/searchIndividuals?search=${value}';
    final responseData = await _helper.getProtected(
        url,  accessToken:Provider.of<Auth>(context, listen: false).accessToken);
    setState(() {
      searchResult = (responseData['content'] as List)
          .map((e) => Profile.fromJson(e))
          .toList();
      print("search");
    });
  }

  // onItemChanged(String value) {
  //   print(value);
  //   setState(() {
  //     newMembersList = members
  //         .where((element) =>
  //             element.name.toUpperCase().contains(value.toUpperCase()))
  //         .toList();
  //   });
  // }

  toggleOrganisationMember(Profile individual, bool isMember) async {
    if (!isMember) {
      final url =
          "authenticated/organisation/addMember/${widget.user.accountId}/${individual.accountId}";
      try {
        var accessToken = Provider.of<Auth>(this.context).accessToken;
        final response =
            await ApiBaseHelper.instance.putProtected(url, accessToken: accessToken);
        await loadMembers();
        print("Success");
        // Navigator.of(this.context).pop(true);
      } catch (error) {
        final responseData = error.body as Map<String, dynamic>;
        print("Failure");
        showDialog(
            context: this.context,
            builder: (ctx) => AlertDialog(
                  title: Text(responseData['error']),
                  content: Text(responseData['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    } else {
      final url =
          "authenticated/organisation/removeMember/${widget.user.accountId}/${individual.accountId}";
      try {
        var accessToken = Provider.of<Auth>(this.context).accessToken;
        final response =
            await ApiBaseHelper.instance.putProtected(url, accessToken: accessToken);
        print("Success");
        // Navigator.of(this.context).pop(true);
      } catch (error) {
        final responseData = error.body as Map<String, dynamic>;
        print("Failure");
        showDialog(
            context: this.context,
            builder: (ctx) => AlertDialog(
                  title: Text(responseData['error']),
                  content: Text(responseData['message']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
      setState(() {});
      await loadMembers();
    }
  }

  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getList();
    members = Provider.of<ManageOrganisationMembers>(context).members;
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.user.name}"),
        ),
        body: _isLoading
            ? Container(child: Center(child: Text("")))
            : GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                    body: SingleChildScrollView(
                                          child: Column(
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
                          onChanged: getSearchedUsers,
                        ),
                      ),
                      SizedBox(height: 20),
                      if (searchResult.isEmpty)
                        Container(
                            child: Center(
                                child: Text(
                                    "Search to find your organisation's members"))),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => SizedBox(height: 5),
                        itemBuilder: (context, index) => ListTile(
                          onTap: () => Navigator.of(context).pushNamed(
                              ProfileScreen.routeName,
                              arguments: searchResult[index].accountId),
                          leading: ClipOval(
                              child: Container(
                            height: 50,
                            width: 50,
                            child:
                                AttachmentImage(searchResult[index].profilePhoto),
                          )),
                          title: Text(searchResult[index].name),
                          trailing: FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                                (members.indexWhere((m) =>
                                            searchResult[index].accountId ==
                                            m.accountId) >=
                                        0)
                                    ? "Remove"
                                    : " Add ",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              bool isMember;
                              if (members.indexWhere((m) =>
                                      searchResult[index].accountId ==
                                      m.accountId) >=
                                  0) {
                                isMember = true;
                              } else {
                                isMember = false;
                              }
                              setState(() {
                                toggleOrganisationMember(
                                    searchResult[index], isMember);
                              });
                            },
                            color: (members.indexWhere((m) =>
                                        searchResult[index].accountId ==
                                        m.accountId) >=
                                    0)
                                ? Colors.red.shade300
                                : Colors.green.shade400,
                          ),
                        ),
                        itemCount: searchResult.length,
                      ),
                  ],
                ),
                    )),
              ));
  }
}
