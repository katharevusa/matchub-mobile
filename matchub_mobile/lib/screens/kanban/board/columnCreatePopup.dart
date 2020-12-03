import 'package:flutter/material.dart';
import 'package:matchub_mobile/services/auth.dart';
import 'package:matchub_mobile/services/kanbanController.dart';
import 'package:matchub_mobile/sizeConfig.dart';
import 'package:matchub_mobile/style.dart';
import 'package:provider/provider.dart';

class ColumnCreatePopup extends StatefulWidget {
  String columnName;
  int columnId;
  ColumnCreatePopup({this.columnName, this.columnId});

  @override
  _ColumnCreatePopupState createState() => _ColumnCreatePopupState();
}

class _ColumnCreatePopupState extends State<ColumnCreatePopup> {
  FocusNode columnNameFocus = FocusNode();
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(columnNameFocus));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final kanbanController =
        Provider.of<KanbanController>(context, listen: false);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 150,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  maxLength: 16,
                  maxLengthEnforced: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter a column name";
                    }
                  },
                  onChanged: (val) {
                    if (val.length <= 16) {
                      widget.columnName = val;
                    }
                  },
                  textCapitalization: TextCapitalization.sentences,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: columnNameFocus,
                  readOnly: isLoading,
                  initialValue: widget.columnName,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      hintText: "New column name...",
                      hintStyle: TextStyle(color: Colors.grey[700])),
                ),
                FlatButton(
                    color: kKanbanColor,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (widget.columnId == null) {
                        await Provider.of<KanbanController>(context,
                                listen: false)
                            .createNewColumn(widget.columnName,
                                Provider.of<Auth>(context).myProfile.accountId);
                      } else {
                        await Provider.of<KanbanController>(context,
                                listen: false)
                            .updateColumn(
                                widget.columnName,
                                Provider.of<Auth>(context).myProfile.accountId,
                                widget.columnId);
                      }
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 2 * SizeConfig.textMultiplier),
                          )),
              ]),
        ),
      ),
    );
  }
}
