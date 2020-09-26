import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  TextEditingController textEditingController;
  Map<String, dynamic> post;
  Function postFunc;
  Profile profile;
  CreatePost(
      this.textEditingController, this.post, this.postFunc, this.profile);
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    Profile currentUser = Provider.of<Auth>(context).myProfile;
    return widget.profile.accountId == currentUser.accountId
        ? TextFormField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
              labelText: 'Write a post',
              hintText: 'What do you want to talk about?',
              labelStyle: TextStyle(color: Colors.grey[850], fontSize: 14),
              fillColor: Colors.grey[100],
              hoverColor: Colors.grey[100],
              suffix: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  widget.postFunc(context);
                  widget.textEditingController.clear();
                  widget.post["content"] = "";
                  FocusScope.of(context).unfocus();
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kSecondaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[850],
                ),
              ),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            maxLength: 500,
            maxLengthEnforced: true,
            onChanged: (text) {
              widget.post["content"] = text;
            },
          )
        : Column();
  }
}
