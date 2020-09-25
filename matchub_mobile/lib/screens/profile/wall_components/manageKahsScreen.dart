import 'package:flutter/material.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/screens/profile/profile_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';

class ManageKahsScreen extends StatefulWidget {
  static const routeName = "/manage-kahs-screen";
  Profile user;
  ManageKahsScreen({
    this.user,
  });
  @override
  _ManageKahsScreenState createState() => _ManageKahsScreenState();
}

class _ManageKahsScreenState extends State<ManageKahsScreen> {
  Future organisationMembersFuture;
  Future kahsFuture;
  ApiBaseHelper _helper = ApiBaseHelper();
  List<Profile> kahs;
  List<Profile> members;
  Profile myProfile;
  List<Profile> newMembersList;
  @override
  void initState() {
    super.initState();
    organisationMembersFuture = getMembers();
    kahsFuture = getKahs();
  }

  getMembers() async {
    final url =
        'authenticated/organisation/viewMembers/${widget.user.accountId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    members = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
    newMembersList = List.from(members);
  }

  getKahs() async {
    final url = 'authenticated/organisation/viewKAHs/${widget.user.accountId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context, listen: false).accessToken);
    kahs = (responseData['content'] as List)
        .map((e) => Profile.fromJson(e))
        .toList();
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

  toggleKahMember(Profile individual, bool isKah) async {
    if (!isKah) {
      final url =
          "authenticated/organisation/addKAH/${widget.user.accountId}/${individual.accountId}";
      try {
        var accessToken = Provider.of<Auth>(this.context).accessToken;
        final response =
            await ApiBaseHelper().putProtected(url, accessToken: accessToken);
        print("Success");
        Navigator.of(this.context).pop(true);
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
          "authenticated/organisation/removeKAH/${widget.user.accountId}/${individual.accountId}";
      try {
        var accessToken = Provider.of<Auth>(this.context).accessToken;
        final response =
            await ApiBaseHelper().putProtected(url, accessToken: accessToken);
        print("Success");
        Navigator.of(this.context).pop(true);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Kahs"),
      ),
      body: FutureBuilder(
        future: Future.wait([organisationMembersFuture, kahsFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) =>
            (snapshot.connectionState == ConnectionState.done)
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
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 5),
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
                            trailing: FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                  (kahs.indexWhere((m) =>
                                              newMembersList[index].accountId ==
                                              m.accountId) >=
                                          0)
                                      ? "Remove"
                                      : " Add ",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () async {
                                bool isKah;
                                if (kahs.indexWhere((m) =>
                                        newMembersList[index].accountId ==
                                        m.accountId) >=
                                    0) {
                                  isKah = true;
                                } else {
                                  isKah = false;
                                }
                                setState(() {
                                  toggleKahMember(newMembersList[index], isKah);
                                });
                              },
                              color: (kahs.indexWhere((m) =>
                                          newMembersList[index].accountId ==
                                          m.accountId) >=
                                      0)
                                  ? Colors.red.shade300
                                  : Colors.green.shade400,
                            ),
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
