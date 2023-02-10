import 'package:expense_tracker/extensions/item_model_extension.dart';
import 'package:expense_tracker/models/model_items.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/paths.dart';
import '../../constants/routes.dart';
import '../../models/model_category.dart';
import '../../services/database.dart';
import '../../shared/text_decoration.dart';
import '../../shared/widgets/category_data_entry.dart';
import '../../shared/widgets/generic_list_tile.dart';
import '../../shared/widgets/loading_screen.dart';
import '../../shared/widgets/today_data_entry.dart';

class TodayList extends StatefulWidget {
  const TodayList({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<TodayList> createState() => _TodayListState();
}

class _TodayListState extends State<TodayList> {


  String itemName = "";
  final globalKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  late String transDate;
  late DateTime currentDate;
  final dateFormatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    currentDate = DateTime.now();
    transDate = dateFormatter.format(currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String pathItem = "${widget.path}${Paths.items}";
    String pathCategory = "${widget.path}${Paths.category}";

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
                  readOnly: true,
                  controller: itemNameController,
                  decoration: fieldStyle.copyWith(
                      hintText: "total",
                      labelText: "today",
                  ),
                  onChanged: (val) {
                    setState(() {
                      itemName = val;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: DatabaseService(path: pathItem).getItemModelReference().
                queryBy(ItemQueryModes.today, filter: transDate).snapshots(),
              builder: (context, items) {

                if (items.hasData) {
                  final itemsData = items.requireData;

                  if (itemsData.size > 0) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: itemsData.size,
                        itemBuilder: (context, index) {
                          return GenericListTile(
                            id: itemsData.docs[index].id,
                            path: pathItem,
                            title: itemsData.docs[index][ItemModel.fieldName],
                            subTitle: itemsData.docs[index][ItemModel.fieldAmount],
                            switchFunction: (item) async {
                              switch(item) {
                                case CategoryEntryMode.add:
                                  break;
                                case CategoryEntryMode.edit:
                                  Navigator.pushNamed(context, Routes.genericRoute,
                                      arguments: {
                                        "widget" : CategoryDataEntry(
                                          entryMode: CategoryEntryMode.edit,
                                          id: itemsData.docs[index].id,
                                          model: CategoryModel(
                                              category: itemsData.docs[index][ItemModel.fieldName]
                                          ),
                                          path: pathItem,
                                        ),
                                        "title" : "Edit Item",
                                      });
                                  break;
                                case CategoryEntryMode.delete:
                                  await DatabaseService(path: pathItem).deleteEntry(itemsData.docs[index].id);
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
              child: FutureBuilder(
                future: DatabaseService(path: pathCategory).getCategoryModelReference().get(),
                builder: (context, categories) {
                  if (categories.hasData) {
                    final categoriesData = categories.requireData;

                    if (categoriesData.size > 0) {
                      List<String> categoriesList = categoriesData.docs.map((
                          docs) {
                        return docs.data().category;
                      }).toList();
                      categoriesList.add("Uncategorized");
                      categoriesList = categoriesList.toSet().toList();

                      return ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.genericRoute,
                                arguments: {
                                  "widget": TodayDataEntry(
                                    entryMode: ExpenseEntryMode.add,
                                    id: "",
                                    model: ItemModel(),
                                    path: pathItem,
                                    categoryList: categoriesList,
                                  ),
                                  "title": "New Item",
                                }
                            );
                          },
                          child: const Text("Add New Item",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          )
                      );
                    }
                    else {
                      return ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.genericRoute,
                                arguments: {
                                  "widget": TodayDataEntry(
                                    entryMode: ExpenseEntryMode.add,
                                    id: "",
                                    model: ItemModel(),
                                    path: pathItem,
                                    categoryList: const ["Uncategorized"],
                                  ),
                                  "title": "New Item",
                                }
                            );
                          },
                          child: const Text("Add New Item",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          )
                      );
                    }
                  }
                  else {
                    return ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.genericRoute,
                              arguments: {
                                "widget": TodayDataEntry(
                                  entryMode: ExpenseEntryMode.add,
                                  id: "",
                                  model: ItemModel(),
                                  path: pathItem,
                                  categoryList: const ["Uncategorized"],
                                ),
                                "title": "New Item",
                              }
                          );
                        },
                        child: const Text("Add New Item",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        )
                    );
                  }
                }
              ),
            ),
          ),
        )
      ],
    );
    /*
    return FutureBuilder(
      future: DatabaseService(path: widget.path).getCategoryModelReference().get(),
      builder: (context, categories) {
        if (categories.hasData) {
          final categoriesData = categories.requireData;

          if (categoriesData.size > 0) {

            List<String> categoriesList = categoriesData.docs.map((docs) {
              return docs.data().category;
            }).toList();
            categoriesList.add("Uncategorized");
            categoriesList = categoriesList.toSet().toList();

            return Column(
              children: [
                Container(
                  color: Theme.of(context).canvasColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                          color: Theme.of(context).primaryColor,
                          child: const Text("0000.00")
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Placeholder(),
                ),
                Container(
                  color: Theme.of(context).canvasColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.genericRoute,
                                arguments: {
                                  "widget" : TodayDataEntry(
                                    entryMode: ExpenseEntryMode.add,
                                    id: "",
                                    model: ItemModel(),
                                    path: widget.path,
                                    categoryList: categoriesList,
                                  ),
                                  "title" : "New Entry",
                                }
                            );
                          },
                          child: const Text("Add New Entry",
                            style: TextStyle(
                                fontSize: 18
                            ),
                          )
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          else {
            return const Center(
              child: Text("No data found"),
            );
          }
        }
        else {
          return const Loading();
        }
      }
    );
    */
  }
}
