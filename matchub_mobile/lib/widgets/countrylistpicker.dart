import 'package:country_list_pick/selection_list.dart';
import 'package:country_list_pick/support/code_countries_en.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:country_list_pick/support/code_countrys.dart';
import 'package:flutter/material.dart';

class CountryListPick2 extends StatefulWidget {
  CountryListPick2({
    this.onChanged,
    this.isShowFlag,
    this.isDownIcon,
    this.isShowCode,
    this.isShowTitle,
    this.initialSelection,
    this.showEnglishName,
    this.appBarBackgroundColor,
  });
  final bool isShowTitle;
  final bool isShowFlag;
  final bool isShowCode;
  final bool isDownIcon;
  final String initialSelection;
  final bool showEnglishName;
  final ValueChanged<CountryCode> onChanged;
  final Color appBarBackgroundColor;

  @override
  _CountryListPick2State createState() {
    List<Map> jsonList = showEnglishName ? countriesEnglish : codes;

    List elements = jsonList
        .map((s) => CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();
    return _CountryListPick2State(elements);
  }
}

class _CountryListPick2State extends State<CountryListPick2> {
  CountryCode selectedItem;
  List elements = [];
  _CountryListPick2State(this.elements);

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.name.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection),
          orElse: () => elements[0] as CountryCode);
    } else {
      selectedItem = elements[0];
    }

    super.initState();
  }

  void _awaitFromSelectScreen(
      BuildContext context, Color appBarBackgroundColor) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionList(
            elements,
            selectedItem,
            appBarBackgroundColor: widget.appBarBackgroundColor,
          ),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      onPressed: () {
        _awaitFromSelectScreen(context, widget.appBarBackgroundColor);
      },
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(child: Container(),),
          if (widget.isShowFlag == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  selectedItem.flagUri,
                  package: 'country_list_pick',
                  width: 32.0,
                ),
              ),
            ),
          if (widget.isShowCode == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(selectedItem.toString()),
              ),
            ),
          if (widget.isShowTitle == true)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(selectedItem.toCountryStringOnly()),
              ),
            ),
          if (widget.isDownIcon == true)
            Flexible(
              child: Icon(Icons.keyboard_arrow_down),
            )
        ],
      ),
    );
  }
}
