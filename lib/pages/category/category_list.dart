import 'package:expense_tracker/shared/widgets/generic_list_tile.dart';
import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../extensions/category_model_extension.dart';
import '../../models/model_category.dart';
import '../../services/database.dart';
import '../../shared/text_decoration.dart';
import '../../shared/widgets/category_data_entry.dart';
import '../../shared/widgets/loading_screen.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  String categoryName = "";
  final globalKey = GlobalKey<FormState>();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          child: Form(
            key: globalKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: categoryController,
                  decoration: fieldStyle.copyWith(
                      hintText: "category",
                      labelText: "search",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              categoryName = "";
                              categoryController.clear();
                            });
                          },
                          icon: categoryName.isNotEmpty ? const Icon(Icons.cancel_outlined) : Container()
                      )
                  ),
                  onChanged: (val) {
                    setState(() {
                      categoryName = val;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: DatabaseService(path: widget.path).getCategoryModelReference().
              queryBy(CategoryQueryModes.name, filter: categoryName).snapshots(),
              builder: (context, categories) {

                if (categories.hasData) {
                  final categoriesData = categories.requireData;

                  if (categoriesData.size > 0) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: categoriesData.size,
                        itemBuilder: (context, index) {
                          return GenericListTile(
                              id: categoriesData.docs[index].id,
                              path: widget.path,
                              title: categoriesData.docs[index][CategoryModel.fieldCATEGORY],
                              switchFunction: (item) async {
                                switch(item) {
                                  case CategoryEntryMode.add:
                                    break;
                                  case CategoryEntryMode.edit:
                                    Navigator.pushNamed(context, Routes.categoryMaintenance,
                                        arguments: {
                                          "widget" : CategoryDataEntry(
                                            entryMode: CategoryEntryMode.edit,
                                            id: categoriesData.docs[index].id,
                                            model: CategoryModel(
                                              category: categoriesData.docs[index][CategoryModel.fieldCATEGORY]
                                            ),
                                            path: widget.path,
                                          ),
                                          "title" : "Edit Category",
                                        });
                                    break;
                                  case CategoryEntryMode.delete:
                                    await DatabaseService(path: widget.path).deleteEntry(categoriesData.docs[index].id);
                                    break;
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

                          );
                        }
                    );
                  }
                  return const Center(
                    child: Text("No data found"),
                  );
                }
                else{
                  return const Loading();
                }
              }
          ),
        ),
        Container(
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.categoryMaintenance,
                        arguments: {
                          "widget" : CategoryDataEntry(
                            entryMode: CategoryEntryMode.add,
                            id: "",
                            model: CategoryModel(),
                            path: widget.path,
                          ),
                          "title" : "New Category",
                        }
                    );
                  },
                  child: Text("Add New Category",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 18
                    ),
                  )
              ),
            ),
          ),
        )
      ],
    );
  }
}
