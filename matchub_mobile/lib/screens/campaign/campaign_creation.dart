import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/screens/resource/resource_detail/ResourceRequest.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/widgets/dialogs.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';
import '../../style.dart';

class CampaignCreationScreen extends StatefulWidget {
  static const routeName = '/fund-campaign';
  @override
  CampaignCreationScreenState createState() => CampaignCreationScreenState();
}

class CampaignCreationScreenState extends State<CampaignCreationScreen> {
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Project> projects;
  String selectedProjectTitle = "Select Project";
  Map<String, dynamic> newCampaign = {
    "campaignTitle": null,
    "campaignDescription": null,
    "campaignTarget": null,
    "endDate": null,
    "projectId": null,
    "payeeId": null,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    projects =
        Provider.of<Auth>(context, listen: false).myProfile.projectsOwned;
    newCampaign['payeeId'] =
        Provider.of<Auth>(context, listen: false).myProfile.accountId;

    return Scaffold(
      appBar: AppBar(
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
          child: Text("Create a new Campaign",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white)),
        ),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 20),
              Text("Lets get you set up!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 10),
              Text(
                  "Pick a project that you want to raise funds for. You cannot change this later.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14, height: 1.4)),
              SizedBox(height: 20),
              AppExpansionTile(
                  key: expansionTile,
                  title: Text(this.selectedProjectTitle,
                      style: TextStyle(
                          color: newCampaign['campaignTitle'] == null
                              ? Colors.black
                              : kKanbanColor)),
                  backgroundColor: kPrimaryColor.withOpacity(0.025),
                  children: <Widget>[
                    for (Project p in projects) ...{
                      new ListTile(
                        title: Text(p.projectTitle),
                        onTap: () {
                          setState(() {
                            this.selectedProjectTitle = p.projectTitle;
                            newCampaign['projectId'] = p.projectId;
                            expansionTile.currentState.collapse();
                          });
                        },
                      ),
                    },
                  ]),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fundraising Campaign Title',
                  hintText: 'Fill in your campaign title here.',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 12),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                maxLength: 50,
                maxLengthEnforced: true,
                initialValue: newCampaign['campaignTitle'],
                onChanged: (value) {
                  newCampaign['campaignTitle'] = value;
                },
                // autovalidateMode: AutovalidateMode.always,
                validator: (newName) {
                  if (newName.isEmpty) {
                    return "Please enter a campaign name";
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Provide more details about your fundraiser here.',
                  labelStyle: TextStyle(color: Colors.grey[850], fontSize: 12),
                  fillColor: Colors.grey[100],
                  hoverColor: Colors.grey[100],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 10,
                initialValue: newCampaign['campaignDescription'],
                onChanged: (value) {
                  newCampaign['campaignDescription'] = value;
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please input a campaign description";
                  }
                },
              ),
              SizedBox(height: 20),
              Container(
                width: 250,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Fundraising Target (\$)',
                    labelStyle:
                        TextStyle(color: Colors.grey[850], fontSize: 12),
                    fillColor: Colors.grey[100],
                    hoverColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kSecondaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    newCampaign['campaignTarget'] = value;
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please input a campaign target";
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Icon(FlutterIcons.calendar_fea, color: Colors.grey[600]),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: 200,
                    child: Theme(
                      data: AppTheme.lightTheme.copyWith(
                        colorScheme:
                            ColorScheme.light(primary: kSecondaryColor),
                      ),
                      child: DateTimePicker(
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please input a campaign end date";
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Campaign End Date',
                          labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 1.6 * SizeConfig.textMultiplier),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 1.6 * SizeConfig.textMultiplier),
                        onChanged: (val) {
                          newCampaign['endDate'] = val + "T00:00:00";
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                    color: kSecondaryColor,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) return;
                      if (newCampaign['projectId'] == null) return;
                      try {
                        await ApiBaseHelper.instance.postProtected(
                            'authenticated/createFundCampaign',
                            body: json.encode(newCampaign));
                            Navigator.pop(context);
                      } catch (error) {
                        print(error.toString());
                        print("Reached");
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Oops! Something went wrong...'),
                            content: Text(error.toString() + "\nPlease set up your Stripe Account under your Profile settings."),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              )
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Submit",
                    ),),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
