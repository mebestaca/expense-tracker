import 'package:flutter/material.dart';

import '../../models/model_items.dart';
import '../text_decoration.dart';

enum ExpenseEntryMode{
  add,
  edit,
  delete
}

class TodayDataEntry extends StatefulWidget {
  const TodayDataEntry({Key? key, required this.entryMode, required this.model, required this.id, required this.path}) : super(key: key);

  final ExpenseEntryMode entryMode;
  final ItemModel model;
  final String id;
  final String path;

  @override
  State<TodayDataEntry> createState() => _TodayDataEntryState();
}

class _TodayDataEntryState extends State<TodayDataEntry> {

  late String itemName;
  late double amount;
  late String transDate;
  late String category;

  final itemNameController = TextEditingController();
  final amountController = TextEditingController();
  final transDateController = TextEditingController();
  final categoryController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isInhibited = false;

  @override
  Widget build(BuildContext context) {

    if (widget.entryMode == ExpenseEntryMode.edit) {
      setState(() {
        if (!isInhibited) {
          itemName = widget.model.name;
          itemNameController.text = itemName;
          isInhibited = true;
        }
      });
    }

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemNameController,
              validator: (val) {
                return val != null && val.isNotEmpty ? null : "please enter an item name";
              },
              decoration: fieldStyle.copyWith(
                  hintText: "date",
                  labelText: "date"
              ),
              onChanged: (val) {
                setState(() {
                  itemName = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemNameController,
              validator: (val) {
                return val != null && val.isNotEmpty ? null : "please enter an item name";
              },
              decoration: fieldStyle.copyWith(
                  hintText: "item name",
                  labelText: "item name"
              ),
              onChanged: (val) {
                setState(() {
                  itemName = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemNameController,
              validator: (val) {
                return val != null && val.isNotEmpty ? null : "please enter an amount";
              },
              decoration: fieldStyle.copyWith(
                  hintText: "amount",
                  labelText: "amount"
              ),
              onChanged: (val) {
                setState(() {
                  itemName = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: itemNameController,
              validator: (val) {
                return val != null && val.isNotEmpty ? null : "please enter an item name";
              },
              decoration: fieldStyle.copyWith(
                  hintText: "category",
                  labelText: "category"
              ),
              onChanged: (val) {
                setState(() {
                  itemName = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()){

                      /*
                      Map<String, dynamic> data = {
                        CategoryModel.fieldCATEGORY : categoryName
                      };

                      final snackBar = SnackBar(
                        content: Text("$categoryName added"),
                        action: SnackBarAction(
                          label: "Ok",
                          onPressed: () {

                          },
                        ),
                      );

                      if (widget.entryMode == CategoryEntryMode.add) {
                        await DatabaseService(path: widget.path).addEntry(data);

                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          categoryController.clear();
                          categoryName = "";
                        });
                      }

                      if (widget.entryMode == CategoryEntryMode.edit) {
                        await DatabaseService(path: widget.path).updateEntry(data, widget.id).then((value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pop(context);
                        });
                      }
                      */
                    }
                  },
                  child: const Text("Confirm")
              ),
            ),
          )
        ],
      ),
    );
  }
}
