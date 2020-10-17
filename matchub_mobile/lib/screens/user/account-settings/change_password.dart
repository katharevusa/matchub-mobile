import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:password_strength/password_strength.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = "/change-password";

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String uuid;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, dynamic> passwordMap = {"password": null};

  @override
  void initState() {
    uuid = Provider.of<Auth>(context, listen: false).myProfile.uuid;
    super.initState();
  }

  void _submitChangePassword() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await ApiBaseHelper.instance.postProtected("authenticated/changePassword/$uuid",
          body: json.encode(passwordMap),
          accessToken: Provider.of<Auth>(context).accessToken);
      Navigator.of(context).pop(true);
    } catch (error) {
      print(error.toString());
      showErrorDialog(error.toString(), context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("Change Password"),
            automaticallyImplyLeading: true,
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 5),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'New Password',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kSecondaryColor, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kSecondaryColor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[850],
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 1,
                              validator: (newPassword) {
                                if (newPassword.length < 8) {
                                  return "Password is too short!";
                                }
                                double strength =
                                    estimatePasswordStrength(newPassword);
                                if (strength < 0.7) {
                                  return ('This password is weak! Please enter a stronger password');
                                }
                              },
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              onChanged: (value) {
                                passwordMap['password'] = value;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kSecondaryColor, width: 0.5),
                                ),
                                labelText: 'Re-enter Password',
                                labelStyle: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kSecondaryColor, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[850],
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 1,
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              validator: (reenterPassword) {
                                if (reenterPassword !=
                                    passwordMap['password']) {
                                  return "The password you've entered does not match!";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          color: kAccentColor.withOpacity(0.9),
                          onPressed: _submitChangePassword,
                          child: Text("Save Changes",
                              style: AppTheme.selectedTabLight))
                    ],
                  ),
                )),
    );
  }
}
