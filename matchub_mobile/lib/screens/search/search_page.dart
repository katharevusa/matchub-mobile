import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/helpers/sdgs.dart';
// import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/search.dart';
import 'package:matchub_mobile/sizeconfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/countrylistpicker.dart';
import 'package:matchub_mobile/widgets/sdgPicker.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:shimmer/shimmer.dart';

import '../../style.dart';
import 'profile_search_card.dart';
import 'project_search_card.dart';

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

  Map<String, dynamic> filterOptions = {
    "country": null,
    "status": null,
    "sdgs": [],
  };

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
    var noOfFilters = 0;
    if (filterOptions['country'] != null) {
      noOfFilters++;
    }
    if (filterOptions['status'] != null) {
      noOfFilters++;
    }
    if (filterOptions['sdgs'].isNotEmpty) {
      noOfFilters++;
    }
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
                    await search.globalSearchForProjects(val, filterOptions: filterOptions);
                  } else {
                    await search.globalSearchForUsers(val, filterOptions: filterOptions);
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
                    hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
              actions: [
                Badge(
                  badgeContent: Text(noOfFilters.toString()),
                  badgeColor: kAccentColor,
                  showBadge: noOfFilters > 0,
                  position: BadgePosition.topStart(
                      top: SizeConfig.heightMultiplier * 0.5,
                      start: SizeConfig.widthMultiplier * 0.5),
                  child: IconButton(
                      icon: Icon(FlutterIcons.sliders_fea),
                      onPressed: () {
                        showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    FilterSheet(filterOptions, searchType))
                            .then((value) async {
                          if (value != null && value) {
                            setState(() {
                              searchComplete = false;
                            });
                            if (searchType == SearchType.PROJECTS) {
                              await search.globalSearchForProjects(searchQuery,
                                  filterOptions: filterOptions);
                            } else {
                              await search.globalSearchForUsers(searchQuery,
                                  filterOptions: filterOptions);
                            }
                            setState(() {
                              searchComplete = true;
                            });
                          }
                        });
                      }),
                )
              ],
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
                      searchQuery: searchQuery,
                    ),
                    SearchProfiles(
                      search: search,
                      searchQuery: searchQuery,
                    ),
                    SearchProfiles(
                      search: search,
                      searchQuery: searchQuery,
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
                ),
        ),
      ),
    );
  }
}

class FilterSheet extends StatefulWidget {
  SearchType searchType;
  Map<String, dynamic> filterOptions;
  FilterSheet(this.filterOptions, this.searchType);
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: 20 * SizeConfig.heightMultiplier,
          maxHeight: 70 * SizeConfig.heightMultiplier),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text("Filter"),
              actions: [
                FlatButton(
                  child: Text("DONE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            if (widget.searchType == SearchType.PROJECTS)
              ListTile(
                leading: Icon(FlutterIcons.clock_fea),
                title: Text("Status"),
                subtitle: Text(widget.filterOptions['status'] ?? ""),
                trailing: Container(
                  width: SizeConfig.widthMultiplier * 29,
                  child: ButtonTheme(
                    padding: EdgeInsets.zero,
                    child: DropdownButtonFormField(
                      isDense: true,
                      selectedItemBuilder: (BuildContext context) {
                        return [
                          'Any',
                          'Pending',
                          'Active',
                          'Completed',
                        ].map<Widget>((String item) {
                          return Text("");
                        }).toList();
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey[900],
                        size: 24,
                      ),
                      style: TextStyle(
                        fontSize: 1.6 * SizeConfig.textMultiplier,
                        color: Colors.grey[850],
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      items: [
                        'Any',
                        'Pending',
                        'Active',
                        'Completed',
                      ].map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                            child: Text(value), value: value);
                      }).toList(),
                      // value: widget.filterOptions['status'],
                      onChanged: (value) {
                        widget.filterOptions['status'] = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ListTile(
              // contentPadding: EdgeInsets.only(left: 16, right: 20),
              leading: Icon(FlutterIcons.map_marked_alt_faw5s),
              title: Text("Country"),
              subtitle: Text(widget.filterOptions['country'] ?? ""),
              trailing: CountryListPick2(
                  // isShowTitle:
                  //     widget.filterOptions['country'] != null ? true : false,
                  isDownIcon: true,
                  //     widget.filterOptions['country'] != null ? true : false,
                  showEnglishName: true,
                  initialSelection: widget.filterOptions['country'],
                  appBarBackgroundColor: kPrimaryColor,
                  onChanged: (CountryCode code) {
                    widget.filterOptions['country'] = code.name;
                    setState(() {});
                  }),
            ),
            ListTile(
              leading: Icon(FlutterIcons.tags_faw5s),
              title: Text("SDGs"),
              onTap: () => Navigator.of(context)
                  .pushNamed(SDGPicker.routeName)
                  .then((value) {
                setState(() {
                  if (value != null) widget.filterOptions['sdgs'] = value;
                  print(value);
                });
              }),
            ),
            if (widget.filterOptions['sdgs'].isNotEmpty) buildSDGTags(),
            FlatButton(
              child: Text("Reset All Filters",
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: SizeConfig.textMultiplier * 1.8)),
              onPressed: () {
                widget.filterOptions['country'] = null;
                widget.filterOptions['status'] = null;
                widget.filterOptions['sdgs'] = [];
                setState(() {});
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildSDGTags() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 1, child: Text("Interests")),
            Flexible(
              flex: 3,
              child: Tags(
                itemCount: widget.filterOptions['sdgs'].length, // required
                itemBuilder: (int index) {
                  return ItemTags(
                    key: Key(index.toString()),
                    index: index, // required
                    title: sdgTitles[widget.filterOptions['sdgs'][index]],
                    color: kScaffoldColor,
                    border: Border.all(color: Colors.grey[400]),
                    textColor: Colors.grey[600],
                    elevation: 0,
                    active: false,
                    pressEnabled: false, textOverflow: TextOverflow.clip,
                    textStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                  );
                },
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.start,
                spacing: 6,
                runSpacing: 6,
              ),
            ),
          ]),
    );
  }
}

class SearchProjects extends StatefulWidget {
  Search search;
  String searchQuery;

  SearchProjects({
    this.search,
    this.searchQuery,
    Key key,
  }) : super(key: key);

  @override
  _SearchProjectsState createState() => _SearchProjectsState();
}

class _SearchProjectsState extends State<SearchProjects> {
  final scrollController = ScrollController();
  int pageNo;
  @override
  void initState() {
    pageNo = 0;
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        await Future.delayed(Duration(seconds: 1));
        if (widget.search.hasMoreProjects) {
          pageNo++;
          await widget.search
              .globalSearchForProjects(widget.searchQuery, pageNo: pageNo);
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      separatorBuilder: (ctx, idx) => Divider(height: 4, thickness: 0),
      itemBuilder: (context, index) {
        if (widget.searchQuery.isEmpty &&
            widget.search.searchProjectResults.isEmpty) return Container();
        if (widget.searchQuery.isNotEmpty &&
            widget.search.searchProjectResults.isEmpty)
          return Container(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 6),
              height: SizeConfig.heightMultiplier * 60,
              child: Column(
                children: [
                  Container(
                      height: 300,
                      child: Image.asset("assets/images/not-found.png")),
                  Text(
                    "Oops, no matches",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We couldn't find any search results, \ntry modifying your query",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, height: 1.5, color: Colors.grey[500]),
                  )
                ],
              ));
        if (index < widget.search.searchProjectResults.length) {
          return ProjectSearchCard(
              project: widget.search.searchProjectResults[index]);
        }
        if (index == widget.search.searchProjectResults.length &&
            widget.search.hasMoreProjects) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
                child: Text(
                    'Didn\'t find what you\'re looking for? \nTry searching for something else!')),
          );
        }
      },
      itemCount: widget.search.searchProjectResults.length + 1,
    );
  }
}

class SearchProfiles extends StatefulWidget {
  Search search;
  String searchQuery;

  SearchProfiles({
    this.search,
    this.searchQuery,
    Key key,
  }) : super(key: key);

  @override
  _SearchProfilesState createState() => _SearchProfilesState();
}

class _SearchProfilesState extends State<SearchProfiles> {
  final scrollController = ScrollController();
  int pageNo;

  @override
  void initState() {
    pageNo = 0;
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        await Future.delayed(Duration(seconds: 1));
        if (widget.search.hasMoreProfiles) {
          pageNo++;
          await widget.search
              .globalSearchForUsers(widget.searchQuery, pageNo: pageNo);
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, idx) => Divider(height: 4, thickness: 0),
      itemBuilder: (context, index) {
        if (widget.searchQuery.isEmpty &&
            widget.search.searchProfileResults.isEmpty) return Container();
        if (widget.search.searchProfileResults.isEmpty)
          return Container(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 6),
              height: SizeConfig.heightMultiplier * 60,
              child: Column(
                children: [
                  Container(
                      height: 300,
                      child: Image.asset("assets/images/not-found.png")),
                  Text(
                    "Oops, no matches",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We couldn't find any search results, \ntry modifying your query",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, height: 1.5, color: Colors.grey[500]),
                  )
                ],
              ));
        if (index < widget.search.searchProfileResults.length) {
          return ProfileVerticalCard(
              profile: widget.search.searchProfileResults[index]);
        }
        if (index == widget.search.searchProfileResults.length &&
            widget.search.hasMoreProfiles) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
                child: Text(
                    'Didn\'t find what you\'re looking for? \nTry searching for seomthing else!')),
          );
        }
      },
      itemCount: widget.search.searchProfileResults.length + 1,
      controller: scrollController,
    );
  }
}
