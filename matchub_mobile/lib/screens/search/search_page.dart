import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/search.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../style.dart';

class SearchResults extends StatefulWidget {
  static const routeName = "search";
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

enum SearchType { PROJECTS, RESOURCES, PROFILES }

String searchTypeToString(SearchType val) {
  if (val == SearchType.PROJECTS) {
    return "Projects";
  }
  if (val == SearchType.RESOURCES) {
    return "Resources";
  }
  if (val == SearchType.PROFILES) {
    return "Profiles";
  }
}

class _SearchResultsState extends State<SearchResults>
    with SingleTickerProviderStateMixin {
  TabController controller;
  String searchQuery;
  SearchType searchType;
  FocusNode searchFocus = new FocusNode();
  bool searchComplete;
  @override
  void initState() {
    searchQuery = "";
    searchComplete = true;
    searchType = SearchType.PROJECTS;
    controller = new TabController(length: 3, vsync: this);
    controller.addListener(() {
      int ind = controller.index;
      if (ind == 0) {
        searchType = SearchType.PROJECTS;
      }
      if (ind == 1) {
        searchType = SearchType.PROFILES;
      }
      if (ind == 2) {
        searchType = SearchType.RESOURCES;
      }
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(searchFocus));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          Search(accessToken: Provider.of<Auth>(context).accessToken),
      child: Consumer<Search>(
        builder: (context, search, child) => Scaffold(
            appBar: AppBar(
                backgroundColor: kScaffoldColor,
                leadingWidth: 40,
                iconTheme: IconThemeData(color: kSecondaryColor),
                title: TextFormField(
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (val) async {
                    setState(() {
                      searchComplete = false;
                    });
                    if (searchType == SearchType.PROJECTS) {
                      await search.globalSearchForProjects(val);
                    } else {
                      await search.globalSearchForUsers(val);
                    }
                    setState(() {
                      searchComplete = true;
                    });
                  },
                  onChanged: (val) => searchQuery = val,
                  initialValue: searchQuery,
                  focusNode: searchFocus,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                      hintText:
                          "Search " + searchTypeToString(searchType) + " ...",
                      hintStyle:
                          TextStyle(fontSize: 20, color: Colors.grey[400]),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none),
                ),
                actions: [IconButton(icon: Icon(FlutterIcons.sliders_fea))],
                primary: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      physics: NeverScrollableScrollPhysics(),
                      // onTap: (x) => controller.animateTo(x),
                      indicatorPadding: EdgeInsets.only(top: 8),
                      labelColor: Colors.grey[600],
                      unselectedLabelColor: Colors.grey[400],
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 4,
                            color: kSecondaryColor,
                            // color: Color(0xFF646464),
                          ),
                          insets: EdgeInsets.only(
                            left: 8,
                            right: 8,
                          )),
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Projects"),
                        Tab(text: "Profiles"),
                        Tab(text: "Resources")
                      ],
                      controller: controller,
                    ),
                  ),
                )),
            body: searchComplete
                ? TabBarView(
                    children: <Widget>[
                      SearchProjects(
                        search: search,
                        searchType: searchType,
                      ),
                      SearchProfiles(
                        search: search,
                        searchType: searchType,
                      ),
                      SearchProfiles(
                        search: search,
                        searchType: searchType,
                      )
                    ],
                    controller: controller,
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: ListView.builder(
                          itemBuilder: (ctx, idx) => ProjectLoader(),
                          itemCount: 10),
                      period: Duration(milliseconds: 800),
                    ),
                  )),
      ),
    );
  }
}

class SearchProjects extends StatelessWidget {
  Search search;
  SearchType searchType;

  SearchProjects({
    this.search,
    this.searchType,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) => Divider(height: 4, thickness: 0),
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsets.symmetric(
                vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ]),
                        width: 24 * SizeConfig.widthMultiplier,
                        height: 24 * SizeConfig.widthMultiplier,
                        child: AttachmentImage(search
                            .searchProjectResults[index].projectProfilePic))),
                Expanded(
                    child:
                        Text(search.searchProjectResults[index].projectTitle))
              ],
            ));
      },
      itemCount: search.searchProjectResults.length,
    );
  }
}

class SearchProfiles extends StatefulWidget {
  Search search;
  SearchType searchType;

  SearchProfiles({
    this.search,
    this.searchType,
    Key key,
  }) : super(key: key);

  @override
  _SearchProfilesState createState() => _SearchProfilesState();
}

class _SearchProfilesState extends State<SearchProfiles> {
  final scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("loading more");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) => Divider(height: 4, thickness: 0),
      itemBuilder: (context, index) {
        if (index < widget.search.searchProfileResults.length) {
          return ProfileVerticalCard(
            profile: widget.search.searchProfileResults[index],
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: Text('You\'ve reached the end!')),
          );
        }
      },
      itemCount: widget.search.searchProfileResults.length + 1,
      controller: scrollController,
    );
  }
}

class ProfileVerticalCard extends StatelessWidget {
  const ProfileVerticalCard({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: 4 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300], width: 1.5),
                  shape: BoxShape.circle),
              height: 60,
              width: 60,
              child: ClipOval(child: AttachmentImage(profile.profilePhoto)),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints:
                      BoxConstraints(maxWidth: SizeConfig.widthMultiplier * 73),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            children: [
                              TextSpan(
                                text: profile.name,
                              ),
                              if (profile.isOrganisation) ...[
                                WidgetSpan(child: SizedBox(width: 2)),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Icon(
                                    FlutterIcons.check_circle_faw5s,
                                    color: kSecondaryColor,
                                    size: 13,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Row(children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.grey[400],
                    size: 12,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "${profile.city}, ${profile.country}",
                    style: AppTheme.searchLight,
                  )
                ]),
                SizedBox(height: 5),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: profile.reputationPoints.toString(),
                      style: AppTheme.selectedTabLight),
                  TextSpan(text: " reputation ⚬ ", style: AppTheme.searchLight),
                  TextSpan(
                      text: profile.followers.length.toString(),
                      style: AppTheme.selectedTabLight),
                  TextSpan(text: " followers", style: AppTheme.searchLight),
                ]))
              ],
            )
          ],
        ));
  }
}

class ProjectLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 260;
    double containerHeight = 15;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
            ),
            height: 100,
            width: 100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
