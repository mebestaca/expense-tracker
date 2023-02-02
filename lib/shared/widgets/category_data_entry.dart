import 'package:expense_tracker/models/model_category.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:expense_tracker/shared/text_decoration.dart';
import 'package:flutter/material.dart';

enum CategoryEntryMode{
  add,
  edit
}

class CategoryDataEntry extends StatefulWidget {
  const CategoryDataEntry({Key? key, required this.entryMode, required this.model, required this.id, required this.path}) : super(key: key);

  final CategoryEntryMode entryMode;
  final CategoryModel model;
  final String id;
  final String path;

  @override
  State<CategoryDataEntry> createState() => _CategoryDataEntryState();
}

class _CategoryDataEntryState extends State<CategoryDataEntry> {

  late String categoryName;
  final categoryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: categoryController,
              validator: (val) {
                return val != null && val.isNotEmpty ? null : "please enter a category";
              },
              decoration: fieldStyle.copyWith(
                hintText: "category",
                labelText: "category"
              ),
              onChanged: (val) {
                setState(() {
                  categoryName = val;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                    if (formKey.currentState!.validate()){

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
                          await DatabaseService(path: widget.path).updateEntry(data, widget.id).then((value) => Navigator.pop(context));
                        }
                    }
                },
                child: const Text("Confirm")
            ),
          ),
        )
      ],
    );
  }
}
