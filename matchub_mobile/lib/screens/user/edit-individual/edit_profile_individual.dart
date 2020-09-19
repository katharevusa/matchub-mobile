import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/screens/user/edit-individual/info_edit_screen.dart';
import 'package:matchub_mobile/screens/user/edit-individual/interest_edit_screen.dart';
import 'package:matchub_mobile/screens/user/select_profile_picture.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class EditIndividualScreen extends StatefulWidget {
  static const routeName = "/edit-individual";
  Profile profile;

  EditIndividualScreen({this.profile});
  @override
  _EditIndividualScreenState createState() => _EditIndividualScreenState();
}

class _EditIndividualScreenState extends State<EditIndividualScreen> {
  Map<String, dynamic> editedProfile;
  @override
  void initState() {
    editedProfile = {
      "id": widget.profile.accountId,
      "firstName": widget.profile.firstName ?? "",
      "lastName": widget.profile.lastName ?? "",
      "phoneNumber": widget.profile.phoneNumber ?? "",
      "countryCode": widget.profile.countryCode ?? "",
      "country": widget.profile.country ?? "",
      "city": widget.profile.city ?? "",
      "profileDescription": widget.profile.profileDescription ?? "",
      "skillSet": widget.profile.skillSet ?? [],
      "sdgIds": widget.profile.sdgs.map((e) => e.sdgId).toList() ?? [],
    };
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  PageController controller = PageController(initialPage: 0, keepPage: true);
  List<dynamic> menu = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Scaffold(
              body: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.15), BlendMode.dstATop),
                    image: AssetImage(
                        "assets/images/edit-screen.png"), // <-- BACKGROUND IMAGE
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              resizeToAvoidBottomInset: false,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
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
                            color: Colors.white)),
                  ),
                  // backgroundColor: kScaffoldColor,
                  elevation: 10,
                ),
              ),
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: controller,
                    children: <Widget>[
                      InfoEditPage(editedProfile, controller),
                      InterestEditPage(
                          editedProfile, controller,),
                      ProfilePhotoPicker(editedProfile, controller, _updateProfile)
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(editedProfile));
      // Provider.of<Auth>(context).retrieveUser();
      
      print(response);
      Provider.of<Auth>(context).myProfile = Profile.fromJson(response);
      print("reached here");
      print(Provider.of<Auth>(context).myProfile.profilePhoto);
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      // final responseData = error.body as Map<String, dynamic>;
      // print("Failure");
      showErrorDialog(error.toString(), context);
      // showDialog(
      //     context: context,
      //     builder: (ctx) => AlertDialog(
      //           title: Text(responseData['error']),
      //           content: Text(responseData['message']),
      //           actions: <Widget>[
      //             FlatButton(
      //               child: Text('Okay'),
      //               onPressed: () {
      //                 Navigator.of(ctx).pop();
      //               },
      //             )
      //           ],
      //         ));
    }
  }
}
