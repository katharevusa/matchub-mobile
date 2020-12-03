import 'package:country_list_pick/support/code_country.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:matchub_mobile/helpers/sdgs.dart';
import 'package:matchub_mobile/screens/search/resources_search.dart';
import 'package:matchub_mobile/screens/search/sdg_target_filter.dart';
import 'package:matchub_mobile/screens/user/select_targets.dart';
// import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/search.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/widgets/attachment_image.dart';
import 'package:matchub_mobile/widgets/campaignCard.dart';
import 'package:matchub_mobile/widgets/countrylistpicker.dart';
import 'package:matchub_mobile/widgets/resourceCategoryPicker.dart';
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

enum SearchType { PROJECTS, RESOURCES, PROFILES, CAMPAIGNS }

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
  if (val == SearchType.CAMPAIGNS) {
    return "Fund Campaigns";
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
    "sdgTargetIds": [],
    "categoryIds": [],
    "startDate": null,
    "endDate": null
  };

  @override
  void initState() {
    searchQuery = "";
    searchComplete = true;
    searchType = SearchType.PROJECTS;
    controller = new TabController(length: 4, vsync: this);
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
      if (ind == 3) {
        searchType = SearchType.CAMPAIGNS;
      }
      filterOptions = {
        "country": null,
        "status": null,
        "sdgs": [],
        "sdgTargetIds": [],
        "categoryIds": [],
        "startDate": null,
        "endDate": null
      };
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(searchFocus));
    super.initState();
  }

  executeSearch(search) async {
    setState(() {
      searchComplete = false;
    });
    if (searchType == SearchType.PROJECTS) {
      await search.globalSearchForProjects(searchQuery,
          filterOptions: filterOptions);
    } else if (searchType == SearchType.PROFILES) {
      await search.globalSearchForUsers(searchQuery,
          filterOptions: filterOptions);
    } else if (searchType == SearchType.RESOURCES) {
      await search.globalSearchForResources(searchQuery,
          filterOptions: filterOptions);
    } else {
      await search.globalSearchForCampaigns(searchQuery,
          filterOptions: filterOptions);
    }
    setState(() {
      searchComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var noOfFilters = 0;
    for (var i in filterOptions.keys) {
      if (filterOptions[i] != null &&
          (i != 'sdgs' && i != 'categoryIds' && i != 'sdgTargetIds')) {
        noOfFilters++;
      }
      if (i == 'sdgs' && filterOptions[i].isNotEmpty) {
        noOfFilters++;
      }
      if (i == 'categoryIds' && filterOptions[i].isNotEmpty) {
        noOfFilters++;
      }
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
                  executeSearch(search);
                  FocusManager.instance.primaryFocus
                      .unfocus(); //VERY IMPORTANT},
                },
                onChanged: (val) => searchQuery = val,
                initialValue: searchQuery,
                focusNode: searchFocus,
                style: TextStyle(
                  fontSize: 20,
                ),
                onEditingComplete: () => searchFocus.unfocus(),
                decoration: InputDecoration(
                    hintText:
                        "Search " + searchTypeToString(searchType) + " ...",
                    hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
              actions: [
                Badge(
                  badgeContent: Text(
                    noOfFilters.toString(),
                  ),
                  badgeColor: kAccentColor.withOpacity(0.8),
                  showBadge: noOfFilters > 0,
                  position: BadgePosition.topStart(
                      top: SizeConfig.heightMultiplier * 0.5,
                      start: SizeConfig.widthMultiplier * 0.5),
                  child: IconButton(
                      icon: Icon(Icons.tune_rounded),
                      onPressed: () {
                        showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    FilterSheet(filterOptions, searchType))
                            .then((value) async {
                          if (value != null && value) {
                            executeSearch(search);
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
                      Tab(text: "Resources"),
                      Tab(text: "Campaigns")
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
                        filterOptions: filterOptions),
                    SearchProfiles(
                        search: search,
                        searchQuery: searchQuery,
                        filterOptions: filterOptions),
                    SearchResources(
                        search: search,
                        searchQuery: searchQuery,
                        filterOptions: filterOptions),
                    SearchCampaigns(
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
  // TextEditingController startTimeController = TextEditingController();
  // TextEditingController endTimeController = TextEditingController();
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
              title: Text("Filters"),
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
            SizedBox(height: 5),
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
                      onChanged: (value) {
                        widget.filterOptions['status'] = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            if (widget.searchType == SearchType.RESOURCES) ...[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        FlutterIcons.clock_fea,
                        color: Colors.grey[700],
                      )),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: Theme(
                        data: AppTheme.lightTheme.copyWith(
                          colorScheme:
                              ColorScheme.light(primary: kSecondaryColor),
                        ),
                        child: DateTimePicker(
                          initialValue: widget.filterOptions['startDate'],
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Start Date',
                          onChanged: (val) {
                            widget.filterOptions['startDate'] = val;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: Theme(
                        data: AppTheme.lightTheme.copyWith(
                          colorScheme:
                              ColorScheme.light(primary: kSecondaryColor),
                        ),
                        child: DateTimePicker(
                          initialValue: widget.filterOptions['endDate'],
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          dateLabelText: 'End Date',
                          onChanged: (val) {
                            widget.filterOptions['endDate'] = val;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              ListTile(
                leading: Icon(FlutterIcons.tags_faw5s),
                title: Text("Category"),
                trailing: Badge(
                    badgeColor: kSecondaryColor,
                    badgeContent: Text(
                        "${widget.filterOptions['categoryIds'].length}",
                        style: TextStyle(color: Colors.white)),
                    showBadge: widget.filterOptions['categoryIds'].isNotEmpty),
                onTap: () => Navigator.of(context)
                    .pushNamed(ResourceCategoryPicker.routeName,
                        arguments: widget.filterOptions['categoryIds'])
                    .then((value) {
                  setState(() {
                    if (value != null)
                      widget.filterOptions['categoryIds'] = value;
                    print(value);
                  });
                }),
              ),
            ],
            ListTile(
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
            if (widget.searchType != SearchType.RESOURCES)
              ListTile(
                leading: Icon(FlutterIcons.tags_faw5s),
                title: Text("SDGs"),
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (_) => SdgTargetFilterScreen(
                            widget.filterOptions['sdgs'],
                            widget.filterOptions['sdgTargetIds'])))
                    .then((value) {
                  if (value != null) {
                    widget.filterOptions['sdgs'] = value['sdgs'];
                    widget.filterOptions['sdgTargetIds'] =
                        value['sdgTargetIds'];
                    setState(() {});
                  }
                }),
              ),
            if (widget.filterOptions['sdgs'].isNotEmpty) buildSDGTags(),
            FlatButton(
              child: Text("Reset All Filters",
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: SizeConfig.textMultiplier * 1.8)),
              onPressed: () {
                setState(() {
                  widget.filterOptions['country'] = null;
                  widget.filterOptions['status'] = null;
                  widget.filterOptions['startDate'] = null;
                  widget.filterOptions['endDate'] = null;
                  widget.filterOptions['categoryIds'] = [];
                  widget.filterOptions['sdgs'] = [];
                });
                Navigator.pop(context);
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
                    title: sdgTitles[widget.filterOptions['sdgs'][index]-1],
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
  Map filterOptions;

  SearchProjects({
    this.search,
    this.searchQuery,
    this.filterOptions,
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
          await widget.search.globalSearchForProjects(widget.searchQuery,
              pageNo: pageNo, filterOptions: widget.filterOptions);
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
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            if (widget.searchQuery.isNotEmpty)
              Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 60,
                  width: 100 * SizeConfig.widthMultiplier,
                  child: Text("Search results for: ${widget.searchQuery}",
                      style: AppTheme.titleLight
                          .copyWith(color: Colors.grey[800]))),
            Container(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                separatorBuilder: (ctx, idx) =>
                    Divider(height: 4, thickness: 0),
                itemBuilder: (context, index) {
                  if (widget.searchQuery.isEmpty &&
                      widget.search.searchProjectResults.isEmpty)
                    return Container();
                  if (widget.searchQuery.isNotEmpty &&
                      widget.search.searchProjectResults.isEmpty)
                    return SearchNotFound();
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchProfiles extends StatefulWidget {
  Search search;
  String searchQuery;
  Map filterOptions;

  SearchProfiles({
    this.search,
    this.searchQuery,
    this.filterOptions,
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
          await widget.search.globalSearchForUsers(widget.searchQuery,
              pageNo: pageNo, filterOptions: widget.filterOptions);
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
        if (widget.search.searchProfileResults.isEmpty) return SearchNotFound();
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
                    'Didn\'t find what you\'re looking for? \nTry searching for something else!')),
          );
        }
      },
      itemCount: widget.search.searchProfileResults.length + 1,
      controller: scrollController,
    );
  }
}

class SearchNotFound extends StatelessWidget {
  const SearchNotFound({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 6),
        height: SizeConfig.heightMultiplier * 60,
        child: Column(
          children: [
            Container(
                height: 300, child: Image.asset("assets/images/not-found.png")),
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
              style:
                  TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[500]),
            )
          ],
        ));
  }
}

class SearchResources extends StatefulWidget {
  Search search;
  String searchQuery;
  Map filterOptions;

  SearchResources({
    this.search,
    this.searchQuery,
    this.filterOptions,
    Key key,
  }) : super(key: key);

  @override
  _SearchResourcesState createState() => _SearchResourcesState();
}

class _SearchResourcesState extends State<SearchResources> {
  final scrollController = ScrollController();
  int pageNo;
  @override
  void initState() {
    pageNo = 0;
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        await Future.delayed(Duration(seconds: 1));
        if (widget.search.hasMoreResources) {
          pageNo++;
          await widget.search.globalSearchForResources(widget.searchQuery,
              pageNo: pageNo, filterOptions: widget.filterOptions);
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
      shrinkWrap: true,
      separatorBuilder: (ctx, idx) => Divider(height: 4, thickness: 0),
      itemBuilder: (context, index) {
        if (widget.searchQuery.isEmpty &&
            widget.search.searchResourcesResults.isEmpty) return Container();
        if (widget.search.searchResourcesResults.isEmpty)
          return SearchNotFound();
        if (index < widget.search.searchResourcesResults.length) {
          return ResourcesSearchCard(
              resource: widget.search.searchResourcesResults[index]);
        }
        if (index == widget.search.searchResourcesResults.length &&
            widget.search.hasMoreResources) {
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
      itemCount: widget.search.searchResourcesResults.length + 1,
      controller: scrollController,
    );
  }
}

class SearchCampaigns extends StatefulWidget {
  Search search;
  String searchQuery;
  Map filterOptions;

  SearchCampaigns({
    this.search,
    this.searchQuery,
    this.filterOptions,
    Key key,
  }) : super(key: key);

  @override
  _SearchCampaignsState createState() => _SearchCampaignsState();
}

class _SearchCampaignsState extends State<SearchCampaigns> {
  final scrollController = ScrollController();
  int pageNo;
  @override
  void initState() {
    pageNo = 0;
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        await Future.delayed(Duration(seconds: 1));
        if (widget.search.hasMoreResources) {
          pageNo++;
          await widget.search.globalSearchForResources(widget.searchQuery,
              pageNo: pageNo, filterOptions: widget.filterOptions);
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      separatorBuilder: (ctx, idx) => Divider(height: 4, thickness: 0),
      itemBuilder: (context, index) {
        if (widget.searchQuery.isEmpty &&
            widget.search.searchCampaignsResults.isEmpty) return Container();
        if (widget.search.searchCampaignsResults.isEmpty)
          return SearchNotFound();
        if (index < widget.search.searchCampaignsResults.length) {
          return FundCampaignCard(widget.search.searchCampaignsResults[index]);
        }
        if (index == widget.search.searchCampaignsResults.length &&
            widget.search.hasMoreCampaigns) {
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
      itemCount: widget.search.searchCampaignsResults.length + 1,
      controller: scrollController,
    );
  }
}
