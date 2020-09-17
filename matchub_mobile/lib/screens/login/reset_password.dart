import 'package:flutter/material.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = "/reset-password";
  String email;
  ResetPassword({this.email});

  Map<String, String> emailMap = {"password": null};

  sendPasswordReset() async {}
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Reset Password"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
                child: Column(children: [
                  Text(
                    "Forgotten your password? \nFret not. Simply enter your email address and we'll send you a password reset link!",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    overflow: TextOverflow.clip,
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset("assets/images/passwordreset.png",
                        height: 30 * SizeConfig.heightMultiplier,
                        fit: BoxFit.contain),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      enabled: true,
                      autofocus: true,
                      initialValue: email,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kSecondaryColor, width: 0.5),
                        ),
                        labelText: 'Enter your email',
                        labelStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 14),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kSecondaryColor, width: 2),
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
                      onChanged: (value) => email = value,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (enter) {
                        if (enter.length == 0) {
                          return "Please enter your email!";
                        }
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text('Send Confirmation Email'),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;
                      try {
                        await ApiBaseHelper().post(
                          "public/forgotPassword?email=$email",
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        showErrorDialog(error.toString(), context);
                      }
                    },
                  )
                ])),
          )),
    );
  }
}
