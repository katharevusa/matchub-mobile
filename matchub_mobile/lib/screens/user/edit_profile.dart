import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/screens/user/info_edit_screen.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";
  Profile profile;

  EditProfileScreen({this.profile});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic> editedProfile;
  @override
  void initState() {
    editedProfile = {
      "id": widget.profile.accountId,
      "firstName": widget.profile.firstName,
      "lastName": widget.profile.lastName,
      "password": "12345678",
      "phoneNumber": widget.profile.phoneNumber,
      "country": widget.profile.country,
      "city": widget.profile.city,
      "profileDescription": widget.profile.profileDescription,
      "skillSet": widget.profile.skillSet,
      "sdgIds": [],
    };
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  PageController controller = PageController(initialPage: 0, keepPage: true);
  List<dynamic> menu = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
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
                child: Text("Edit Profile Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey[850])),
              ),
              backgroundColor: kScaffoldColor,
              elevation: 0,
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: controller,
                children: <Widget>[
                  InfoEditPage(editedProfile),
                  Container(
                      child: Center(
                          child: FlatButton(
                    child: Text("Submit"),
                    onPressed: () => _updateProfile(
                        Provider.of<Auth>(context).accessToken, context),
                  )))
                ],
              ),
            ),
          ),
        ));
  }

  void _updateProfile(accessToken, context) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    final url = "authenticated/updateIndividual";
    print(url);
    print(editedProfile['lastName']);
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(editedProfile));
      Provider.of<Auth>(context).retrieveUser();
      print("Success");
      Navigator.of(context).pop();
    } catch (error) {
      final responseData = error.body as Map<String, dynamic>;
      print("Failure");
      showDialog(
          context: context,
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
