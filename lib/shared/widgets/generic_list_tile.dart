import 'package:expense_tracker/shared/widgets/category_data_entry.dart';
import 'package:expense_tracker/shared/widgets/generic_popup_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GenericListTile extends StatefulWidget {
  const GenericListTile({Key? key, required this.id, required this.path, required this.title, required this.switchFunction, required this.popUpMenuItemList, required this.subTitle}) : super(key: key);

  final String id;
  final String path;
  final String title;
  final String subTitle;
  final Function switchFunction;
  final List<PopupMenuItem> popUpMenuItemList;

  @override
  State<GenericListTile> createState() => _GenericListTileState();
}

class _GenericListTileState extends State<GenericListTile> {

  CategoryEntryMode? selectedMenu;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,##0.00');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 3.0
      ),
      child: Card(
        child: ListTile(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
          ),
          title: Text(widget.title),
          subtitle: SizedBox(
            width: double.infinity,
            child: Text(widget.subTitle.isNotEmpty ? formatter.format(double.parse(widget.subTitle.replaceAll(",", ""))) : widget.subTitle,
              textAlign: TextAlign.end,
            ),
          ),
          trailing: widget.popUpMenuItemList.isEmpty ? const SizedBox() : GenericPopUpMenuButton(
            switchFunction: (item) async {
              widget.switchFunction(item);
            },
            popUpMenuItemList: widget.popUpMenuItemList,
          ),
        ),
      ),
    );
  }
}
