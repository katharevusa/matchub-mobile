import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/api/api_helper.dart';
import 'package:matchub_mobile/models/profile.dart';
import 'package:matchub_mobile/models/project.dart';
import 'package:matchub_mobile/models/resourceCategory.dart';
import 'package:matchub_mobile/models/resourceRequest.dart';
import 'package:matchub_mobile/models/resources.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/style.dart';
import 'package:matchub_mobile/widgets/errorDialog.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

class RequestFormScreen extends StatefulWidget {
  Resources resource;
  RequestFormScreen(this.resource);

  @override
  _RequestFormScreenState createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  Profile resourceOwner;
  Future resourceOwnerFuture;
  // Future categoryFuture;
  ApiBaseHelper _helper = ApiBaseHelper();
  ResourceCategory category;
  ResourceRequest newResourceRequest = new ResourceRequest();
  Map<String, dynamic> resourceRequest;
  List<Project> projects;
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  String foos = 'Select project';
  double _n = 0;
  int total = 0;
  @override
  @override
  void initState() {
    super.initState();
    resourceOwnerFuture = getResourceOwner();
    // categoryFuture = getCategoryById();
    resourceRequest = {
      'requestId': newResourceRequest.requestId,
      'requestCreationTime': newResourceRequest.requestCreationTime,
      'status': newResourceRequest.status,
      'requestorId': newResourceRequest.requestorId,
      'requestorEnum': newResourceRequest.requestorEnum,
      'resourceId': newResourceRequest.resourceId,
      'projectId': newResourceRequest.projectId ?? null,
      'unitsRequired': newResourceRequest.unitsRequired ?? 1,
      'message': newResourceRequest.message ?? "",
    };
  }

/* Start of Backend method*/
  getCategoryById() async {
    final url =
        'authenticated/getResourceCategoryById?resourceCategoryId=${widget.resource.resourceCategoryId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(this.context).accessToken);
    category = ResourceCategory.fromJson(responseData);
  }

  getResourceOwner() async {
    final url = 'authenticated/getAccount/${widget.resource.resourceOwnerId}';
    final responseData = await _helper.getProtected(
        url, Provider.of<Auth>(context, listen: false).accessToken);
    resourceOwner = Profile.fromJson(responseData);
    await getCategoryById();
  }

  request() async {
    resourceRequest["requestorId"] =
        Provider.of<Auth>(context).myProfile.accountId;
    resourceRequest['resourceId'] = widget.resource.resourceId;
    final url = "authenticated/createNewResourceRequestByProjectOwner";
    var accessToken = Provider.of<Auth>(context).accessToken;
    try {
      final response = await ApiBaseHelper().postProtected(url,
          accessToken: accessToken, body: json.encode(resourceRequest));
      print("Success");
      Navigator.of(context).pop(true);
    } catch (error) {
      showErrorDialog(error.toString(), context);
    }
  }

/* End of Backend method*/

  @override
  Widget build(BuildContext context) {
    final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
    projects = Provider.of<Auth>(context).myProfile.projectsOwned;
    return FutureBuilder(
      future: resourceOwnerFuture,
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.done)
          ? Scaffold(
              appBar: AppBar(
                title: Text("Resource request form"),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "New Request",
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        "Please fill in the request form:",
                        style: label,
                      ),
                      Divider(),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "RESOURCE NAME",
                            style: label,
                          ),
                          Text("OWNER", style: label)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(widget.resource.resourceName),
                          Text(resourceOwner.name),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "AMOUNT WANTED:",
                            style: label,
                          ),
                          Text(
                              (category.perUnit * _n).toString() +
                                  category.unitName,
                              style: label)
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.red[700],
                          inactiveTrackColor: Colors.red[100],
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          thumbColor: Colors.redAccent,
                          overlayColor: Colors.red.withAlpha(32),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          activeTickMarkColor: Colors.red[700],
                          inactiveTickMarkColor: Colors.red[100],
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.redAccent,
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider(
                          min: 0,
                          max: widget.resource.units.toDouble(),
                          value: _n,
                          label: '$_n',
                          divisions: 10,
                          onChanged: (value) {
                            if (this.mounted) {
                              setState(() {
                                _n = value;
                              });
                            }
                            resourceRequest['unitsRequired'] = value;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "MATCH RESOURCE TO:",
                            style: label,
                          ),
                        ],
                      ),
                      AppExpansionTile(
                          key: expansionTile,
                          title: new Text(this.foos),
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.025),
                          children: <Widget>[
                            for (Project p in projects) ...{
                              new ListTile(
                                title: Text(p.projectTitle),
                                onTap: () {
                                  setState(() {
                                    this.foos = p.projectTitle;
                                    resourceRequest['projectId'] = p.projectId;
                                    expansionTile.currentState.collapse();
                                  });
                                },
                              ),
                            },
                          ]),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Message to resource owner',
                          hintText: 'Type you message here...',
                          labelStyle:
                              TextStyle(color: Colors.grey[850], fontSize: 14),
                          fillColor: Colors.grey[100],
                          hoverColor: Colors.grey[100],
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
                        minLines: 3,
                        maxLines: 3,
                        maxLength: 500,
                        maxLengthEnforced: true,
                        onChanged: (text) {
                          resourceRequest['message'] = text;
                        },
                      ),
                      Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                            child: Text("Send"),
                            onPressed: () {
                              request();
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, true);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class AppExpansionTile extends StatefulWidget {
  const AppExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children: const <Widget>[],
    this.trailing,
    this.initiallyExpanded: false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;
  final Color backgroundColor;
  final Widget trailing;
  final bool initiallyExpanded;

  @override
  AppExpansionTileState createState() => new AppExpansionTileState();
}

const Duration _kExpand = const Duration(milliseconds: 200);

class AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _easeOutAnimation;
  CurvedAnimation _easeInAnimation;
  ColorTween _borderColor;
  ColorTween _headerColor;
  ColorTween _iconColor;
  ColorTween _backgroundColor;
  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _easeInAnimation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _borderColor = new ColorTween();
    _headerColor = new ColorTween();
    _iconColor = new ColorTween();
    _iconTurns =
        new Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = new ColorTween();

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded)
          _controller.forward();
        else
          _controller.reverse().then<void>((value) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor =
        _borderColor.evaluate(_easeOutAnimation) ?? Colors.transparent;
    final Color titleColor = _headerColor.evaluate(_easeInAnimation);

    return new Container(
      decoration: new BoxDecoration(
          color: _backgroundColor.evaluate(_easeOutAnimation) ??
              Colors.transparent,
          border: new Border(
            top: new BorderSide(color: borderSideColor),
            bottom: new BorderSide(color: borderSideColor),
          )),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data:
                new IconThemeData(color: _iconColor.evaluate(_easeInAnimation)),
            child: new ListTile(
              onTap: toggle,
              leading: widget.leading,
              title: new DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: titleColor),
                child: widget.title,
              ),
              trailing: widget.trailing ??
                  new RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.expand_more),
                  ),
            ),
          ),
          new ClipRect(
            child: new Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor.end = theme.dividerColor;
    _headerColor
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColor
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColor.end = widget.backgroundColor;

    final bool closed = !_isExpanded && _controller.isDismissed;
    return new AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : new Column(children: widget.children),
    );
  }
}
