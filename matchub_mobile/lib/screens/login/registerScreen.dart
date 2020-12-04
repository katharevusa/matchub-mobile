import 'package:flutter/material.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:password_strength/password_strength.dart';
import 'package:matchub_mobile/helpers/validation.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";

  RegisterScreen();

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageController _controller = PageController(initialPage: 0, keepPage: true);

  bool isOrganisation = false;
  Map<String, dynamic> newStakeholder;
  @override
  void initState() {
    newStakeholder = {
      "organisationName": "",
      "firstName": "",
      "lastName": "",
      "email": "",
      "password": "",
      "roles": ["USER"],
    };
    super.initState();
  }

  registerUser() async {
    if (!_formKey.currentState.validate()) return;
    try {
      String url = "";
      if (isOrganisation) {
        url = "public/createNewOrganisation";
      } else {
        url = "public/createNewIndividual";
      }
      await ApiBaseHelper.instance.post(url, body: json.encode(newStakeholder));
      print("Success");
      Navigator.pop(context);
    } catch (error) {
      print("Failure");
      showErrorDialog(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Register your Account"),
            centerTitle: true,
          ),
          body: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
                child: PageView(
                  controller: _controller,
                  children: <Widget>[
                    AuthDetails(newStakeholder, _controller),
                    BasicDetails(isOrganisation, newStakeholder, registerUser)
                  ],

                  // new Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     new Radio(
                  //       value: false,
                  //       groupValue: true,
                  //       onChanged: (value)=> _handleStakeholderChange(value),
                  //     ),
                  //     new Text(
                  //       'Individual',
                  //       style: new TextStyle(fontSize: 16.0),
                  //     ),
                  //     new Radio(
                  //       value: true,
                  //       groupValue: true,
                  //       onChanged:(value)=>  _handleStakeholderChange(value),
                  //     ),
                  //     new Text(
                  //       'Organisation',
                  //       style: new TextStyle(
                  //         fontSize: 16.0,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // FlatButton(
                  //   child: Text('Send Confirmation Email'),
                  //   onPressed: () async {
                  //     if (!_formKey.currentState.validate()) return;
                  //     try {
                  //       await ApiBaseHelper.instance.post(
                  //         "public/forgotPassword?email=$email",
                  //       );
                  //       Navigator.of(context).pop();
                  //     } catch (error) {
                  //       showErrorDialog(error.toString(), context);
                  //     }
                  //   },
                  // )
                ),
              )),
        ));
  }
}

class AuthDetails extends StatefulWidget {
  Map<String, dynamic> newStakeholder;
  PageController _controller;

  AuthDetails(this.newStakeholder, this._controller);

  @override
  _AuthDetailsState createState() => _AuthDetailsState();
}

class _AuthDetailsState extends State<AuthDetails>
    with AutomaticKeepAliveClientMixin<AuthDetails> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Text(
          "The World's #1 Knowledge Community for Sustainable Development",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          overflow: TextOverflow.clip,
        ),
        Opacity(
          opacity: 0.8,
          child: Image.asset("assets/images/register.png",
              height: 30 * SizeConfig.heightMultiplier, fit: BoxFit.cover),
        ),
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
            ),
            labelText: 'Enter your email',
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 2),
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
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 1,
          onChanged: (value) => widget.newStakeholder['email'] = value,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (enter) {
            if (enter.length == 0) {
              return "Please enter your email!";
            } else if (!validateEmail(enter)) {
              return "Please enter a valid email address";
            }
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: 'New Password',
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 2),
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
            double strength = estimatePasswordStrength(newPassword);
            if (strength < 0.7) {
              return ('This password is weak! Please enter a stronger password');
            }
          },
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            widget.newStakeholder['password'] = value;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
            ),
            labelText: 'Re-enter Password',
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 2),
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
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (reenterPassword) {
            if (reenterPassword != widget.newStakeholder['password']) {
              return "The password you've entered does not match!";
            }
          },
        ),
        SizedBox(height: 20),
        RaisedButton(
          child: Text("Next"),
          onPressed: () => widget._controller.jumpToPage(1),
        )
      ],
    ));
  }
}

class BasicDetails extends StatefulWidget {
  Function registerUser;
  bool isOrganisation;
  Map<String, dynamic> newStakeholder;
  BasicDetails(this.isOrganisation, this.newStakeholder, this.registerUser);

  @override
  _BasicDetailsState createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails>
    with AutomaticKeepAliveClientMixin<BasicDetails> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Text(
        'I am signing up as an: ',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      RadioListTile<bool>(
        title: Text("Individual"),
        // toggleable: true,
        value: false,
        groupValue: widget.isOrganisation,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (bool value) {
          setState(() {
            widget.isOrganisation = value;
          });
        },
      ),
      RadioListTile<bool>(
        title: Text("Organisation"),
        // toggleable: true,
        value: true,
        groupValue: widget.isOrganisation,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (bool value) {
          setState(() {
            widget.isOrganisation = value;
          });
        },
      ),
      Visibility(
        visible: widget.isOrganisation,
        child: TextFormField(
          enabled: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
            ),
            labelText: 'Organisation Name',
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 2),
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
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 1,
          onChanged: (value) =>
              widget.newStakeholder['organisationName'] = value,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (enter) {
            if (enter.length == 0) {
              return "Please enter your organisation's name!";
            }
          },
        ),
      ),
      if (!widget.isOrganisation) ...[
        TextFormField(
          enabled: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
            ),
            labelText: 'First Name',
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 2),
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
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 1,
          onChanged: (value) => widget.newStakeholder['firstName'] = value,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (enter) {
            if (enter.length == 0) {
              return "Please enter your first name!";
            }
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          enabled: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 0.5),
            ),
            labelText: 'Last Name',
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kSecondaryColor, width: 2),
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
          keyboardType: TextInputType.text,
          minLines: 1,
          maxLines: 1,
          onChanged: (value) => widget.newStakeholder['lastName'] = value,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
      FlatButton(
          child: Text('Register Account'),
          onPressed: () => widget.registerUser())
    ]));
  }
}
