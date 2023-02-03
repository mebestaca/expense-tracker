import 'package:expense_tracker/constants/routes.dart';
import 'package:expense_tracker/models/model_category.dart';
import 'package:expense_tracker/shared/widgets/category_data_entry.dart';
import 'package:expense_tracker/shared/widgets/generic_popup_menu_button.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';

class GenericListTile extends StatefulWidget {
  const GenericListTile({Key? key, required this.id, required this.model, required this.path}) : super(key: key);

  final String id;
  final String path;
  final CategoryModel model;

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
        title: Text(widget.model.category),
        trailing: GenericPopUpMenuButton(
          switchFunction: (item) async {
            switch(item) {
              case CategoryEntryMode.add:
                break;
              case CategoryEntryMode.edit:
                Navigator.pushNamed(context, Routes.categoryMaintenance,
                    arguments: {
                      "widget" : CategoryDataEntry(
                        entryMode: CategoryEntryMode.edit,
                        id: "",
                        model: CategoryModel(),
                        path: widget.path,
                      ),
                      "title" : "New Category",
                    });
                break;
              case CategoryEntryMode.delete:
                await DatabaseService(path: widget.path).deleteEntry(widget.id);
            }
          },
          popUpMenuItemList: const [
            PopupMenuItem<CategoryEntryMode>(
                value: CategoryEntryMode.edit,
                child: Text("Edit")
            ),
            PopupMenuItem<CategoryEntryMode>(
                value: CategoryEntryMode.delete,
                child: Text("Delete")
            ),
          ],
        ),
      ),
    );
  }
}
