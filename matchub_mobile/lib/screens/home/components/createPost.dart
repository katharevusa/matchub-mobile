import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/helpers/attachmentHelper.dart';
import 'package:matchub_mobile/helpers/uploadHelper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

import '../../../style.dart';

class CreatePostScreen extends StatefulWidget {
  static const routeName = '/create-post';
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  Profile myProfile;
  bool isSending = false;
  bool isKeyboardVisible = false;
  bool isEmojiVisible = false;
  final controller = TextEditingController();
  final focusNode = FocusNode();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  String _postContent = "";
  final GlobalKey<FormState> formController = GlobalKey();
  List<File> attachments = [];

  @override
  void initState() {
    KeyboardVisibility.onChange.listen((bool isKeyboardVisible) {
      if (mounted) {
        setState(() {
          this.isKeyboardVisible = isKeyboardVisible;
        });

        if (isKeyboardVisible && isEmojiVisible) {
          setState(() {
            isEmojiVisible = false;
          });
        }
      }
    });
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(focusNode));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myProfile = Provider.of<Auth>(context, listen: false).myProfile;
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 30,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: OutlineButton(
                borderSide: BorderSide(color: Colors.white),
                visualDensity: VisualDensity.compact,
                child: Text(
                  "Post",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () async {
                  await sendPost();
                },
              ),
            )
          ],
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text("Create post",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white)),
          ),
          // backgroundColor: kScaffoldColor,
          elevation: 10,
        ),
        body: LoadingOverlay(
          isLoading: isSending,
          color: Colors.blueGrey[200],
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 20),
                  ListTile(
                    dense: true,
                    leading: ClipOval(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: AttachmentImage(myProfile.profilePhoto)),
                    ),
                    title: Text(
                      "${myProfile.name}",
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Form(
                    key: formController,
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: controller,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please enter a message";
                        }
                      },
                      // onFieldSubmitted: (_) =>
                      //     FocusManager.instance.primaryFocus.unfocus(),
                      decoration: InputDecoration(
                        errorMaxLines: 1,
                        hintText: 'What do you want to talk about?',
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 18),
                        contentPadding: const EdgeInsets.all(20),
                        border: InputBorder.none,
                      ),
                      minLines: 5,
                      maxLines: 10,
                      onChanged: (val) => _postContent = val,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _text,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 90,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: attachments.length,
                      itemBuilder: (_, index) {
                        var document = attachments[index];
                        var fileName;
                        if (path.extension(document.path) == '.mp4') {
                          fileName = "Video";
                        } else if (path.extension(document.path) == '.jpg' ||
                            path.extension(document.path) == '.png') {
                          fileName = "Image";
                        } else {
                          fileName = document.path;
                        }
                        return GestureDetector(
                          onTap: () async {
                            String url = ApiBaseHelper.instance.baseUrl +
                                document.path.substring(30);
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          onLongPress: () {
                            showMenu(
                              position: RelativeRect.fromLTRB(
                                  (index.toDouble() + 1) * (140 + 10),
                                  80 * SizeConfig.heightMultiplier,
                                  SizeConfig.widthMultiplier * 100 -
                                      index.toDouble() * (140 / 2),
                                  0),
                              items: <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: "del",
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    dense: true,
                                    leading: Icon(FlutterIcons.trash_alt_faw5s,
                                        color: Colors.grey[700]),
                                    title: Text("Remove",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.8)),
                                  ),
                                )
                              ],
                              context: context,
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      0.5 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey[100],
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: (fileName == "Image"
                                          ? FileImage(document)
                                          : AssetImage(
                                              "assets/images/announcement.png")),
                                      fit: BoxFit.cover)),
                              height: 90,
                              width: 140,
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 16),
                              child: Row(
                                children: [
                                  Container(
                                      width: 25,
                                      child: getDocumentImage(document.path)),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(fileName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                ])),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: kScaffoldColor,
                  width: 100 * SizeConfig.widthMultiplier,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.emoji_emotions_outlined,
                                    color: Colors.blueGrey[300], size: 28),
                                onPressed: onClickedEmoji),
                            IconButton(
                                icon: Icon(Icons.attachment,
                                    color: Colors.blueGrey[300], size: 28),
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            topLeft: Radius.circular(15.0)),
                                      ),
                                      context: context,
                                      builder: (ctx) {
                                        return UploadImagePopup();
                                      }).then((value) async {
                                    if (value != null) {
                                      attachments.addAll(value);
                                    }
                                  });
                                }),
                          ],
                        ),
                        IconButton(
                          onPressed: _listen,
                          icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.blueGrey[300], size: 28),
                        ),
                      ]),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Offstage(
                  child: EmojiPickerWidget(
                    onEmojiSelected: onEmojiSelected,
                  ),
                  offstage: !isEmojiVisible,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isListening
            ? AvatarGlow(
                animate: _isListening,
                glowColor: kKanbanColor,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: FloatingActionButton(
                  onPressed: _listen,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                ),
              )
            : Container(),
      ),
    );
  }

  Future<bool> onBackPress() {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  void onEmojiSelected(String emoji) => setState(() {
        print("0");
        controller.text = controller.text + emoji;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      });

  void onClickedEmoji() async {
    if (isEmojiVisible) {
      print("a");
      // focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      print("b");
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(Duration(milliseconds: 100));
    }
    toggleEmojiKeyboard();
  }

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
      print("c");
    }

    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        Future.delayed(Duration(seconds: 6), () {
          stopListening();
        });
        setState(() => _isListening = true);
        _speech.listen(
          cancelOnError: true,
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      stopListening();
    }
  }

  stopListening() {
    setState(() {
      _isListening = false;
      if (_text.isNotEmpty) {
        controller.text = controller.text + _text + " ";
      }
      setState(() {
        _text = "";
      });
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    });
    _speech.stop();
  }

  sendPost() async {
    if (controller.text.isNotEmpty && formController.currentState.validate()) {
      setState(() => isSending = true);
      Post createdPost = Post.fromJson(
        await ApiBaseHelper.instance.postProtected(
          "authenticated/createPost",
          body: json.encode({
            "content": controller.text,
            "postCreatorId":
                Provider.of<Auth>(context, listen: false).myProfile.accountId
          }),
        ),
      );

      await uploadMultiFile(
        attachments,
        "${ApiBaseHelper.instance.baseUrl}authenticated/post/uploadPhotos/${createdPost.postId}",
        Provider.of<Auth>(context, listen: false).accessToken,
        "photos",
      );
      setState(() => isSending = false);
      Navigator.pop(context);
    }
  }
}

class EmojiPickerWidget extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerWidget({
    @required this.onEmojiSelected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => EmojiPicker(
        rows: 5,
        columns: 7,
        onEmojiSelected: (emoji, category) => onEmojiSelected(emoji.emoji),
      );
}
