import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/info_edit_screen.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/interest_edit_screen.dart';
import 'package:matchub_mobile/screens/user/edit-organisation/uploadVerificationDocument.dart';
import 'package:matchub_mobile/screens/user/select_profile_picture.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class EditOrganisationScreen extends StatefulWidget {
  static const routeName = "/edit-organisation";
  Profile profile;

  EditOrganisationScreen({this.profile});
  @override
  _EditOrganisationScreenState createState() => _EditOrganisationScreenState();
}

class _EditOrganisationScreenState extends State<EditOrganisationScreen> {
  Map<String, dynamic> editedProfile;
  @override
  void initState() {
    editedProfile = {
      "id": widget.profile.accountId,
      "organizationName": widget.profile.name,
      "phoneNumber": widget.profile.phoneNumber ?? "",
      "countryCode": widget.profile.countryCode ?? "",
      "country": widget.profile.country ?? "",
      "city": widget.profile.city ?? "",
      "organizationDescription": widget.profile.profileDescription ?? "",
      "areasOfExpertise": widget.profile.skillSet ?? [],
      "sdgIds": widget.profile.sdgs.map((e) => e.sdgId).toList() ?? [],
      "address": widget.profile.address ?? ""
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
                            fontWeight: FontWeight.w600,
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
                          editedProfile, controller, _updateProfile),
                      ProfilePhotoPicker(
                          editedProfile, controller, _updateProfile),
                      //is organisation then return this
                      UploadVerificationDocument(
                          editedProfile, controller, _updateProfile),
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
      print("Form is invalid");
      return;
    }
    _formKey.currentState.save();
    final url = "authenticated/updateOrganisation";
    try {
      final response = await ApiBaseHelper.instance.postProtected(url,
          accessToken: accessToken, body: json.encode(editedProfile));
      Provider.of<Auth>(context,listen: false).myProfile = Profile.fromJson(response);
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      final responseData = error.body as Map<String, dynamic>;
      print("Failure");
      showErrorDialog(error.toString(), context);
    }
  }
}
