import 'package:expense_tracker/shared/widgets/category_data_entry.dart';
import 'package:expense_tracker/shared/widgets/generic_popup_menu_button.dart';
import 'package:flutter/material.dart';

class GenericListTile extends StatefulWidget {
  const GenericListTile({Key? key, required this.id, required this.path, required this.title, required this.switchFunction, required this.popUpMenuItemList}) : super(key: key);

  final String id;
  final String path;
  final String title;
  final Function switchFunction;
  final List<PopupMenuItem> popUpMenuItemList;

  @override
  State<GenericListTile> createState() => _GenericListTileState();
}

class _GenericListTileState extends State<GenericListTile> {

  CategoryEntryMode? selectedMenu;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 3.0
      ),
      child: ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
        title: Text(widget.title),
        trailing: GenericPopUpMenuButton(
          switchFunction: (item) async {
            widget.switchFunction(item);
          },
          popUpMenuItemList: widget.popUpMenuItemList,
        ),
      ),
    );
  }
}
