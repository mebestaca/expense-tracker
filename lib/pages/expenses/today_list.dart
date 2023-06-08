import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/extensions/item_model_extension.dart';
import 'package:expense_tracker/models/model_items.dart';
import 'package:expense_tracker/shared/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/paths.dart';
import '../../constants/routes.dart';
import '../../services/database.dart';
import '../../shared/white_style.dart';
import '../../shared/widgets/generic_list_tile.dart';
import '../../shared/widgets/loading_screen.dart';
import '../../shared/widgets/today_data_entry.dart';

class TodayList extends StatefulWidget {
  const TodayList({Key? key, required this.path, required this.year, required this.month, required this.day}) : super(key: key);

  final String year;
  final String month;
  final String day;
  final String path;

  @override
  State<TodayList> createState() => _TodayListState();
}

class _TodayListState extends State<TodayList> {


  String itemName = "";
  final globalKey = GlobalKey<FormState>();
  late String transDate;
  late DateTime currentDate;
  final dateFormatter = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    currentDate = DateTime(
        int.parse(widget.year),
        int.parse(widget.month),
        int.parse(widget.day)
    );
    transDate = dateFormatter.format(currentDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String pathItem = "${widget.path}${Paths.items}";
    String pathCategory = "${widget.path}${Paths.category}";

    return FutureBuilder(
      future: DatabaseService(path: pathCategory).getCategoryModelReference().get(),
      builder: (context, categories){
        if (categories.hasData) {
          final categoriesData = categories.requireData;

          List<String> categoriesList = categoriesData.docs.map((
              docs) {
            return docs.data().category;
          }).toList();
          categoriesList.add("Uncategorized");
          categoriesList = categoriesList.toSet().toList();

          return Stack(
            children: [
              const Background(),
              Column(
                children: [
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: StreamBuilder(
                          stream: DatabaseService(path: pathItem).getItemModelReference().
                          queryBy(ItemQueryModes.today, filter: transDate).snapshots(),
                          builder: (context, items) {

                            if (items.hasData) {

                              final itemsData = items.data;

                              return StreamBuilder(
                                stream: calculateSum(itemsData),
                                builder: (context, sum) {
                                  if (sum.hasData) {
                                    final sumData = sum.data;
                                    return ListTile(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      title: Text(sumData!,
                                        textAlign: TextAlign.end,
                                      ),
                                    );
                                  }
                                  else{
                                    return ListTile(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      title: const Text("0",
                                        textAlign: TextAlign.end,
                                      ),
                                    );
                                  }
                                }
                              );
                            }
                            else {
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                title: const Text("Loading"),
                              );
                            }
                          },
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
                                          case ExpenseEntryMode.add:
                                            break;
                                          case ExpenseEntryMode.edit:
                                            Navigator.pushNamed(context, Routes.genericRoute,
                                                arguments: {
                                                  "widget": TodayDataEntry(
                                                    entryMode: ExpenseEntryMode.edit,
                                                    id: itemsData.docs[index].id,
                                                    model: ItemModel(
                                                      amount: double.parse(itemsData.docs[index][ItemModel.fieldAmount]),
                                                      transDate: itemsData.docs[index][ItemModel.fieldDate],
                                                      category: itemsData.docs[index][ItemModel.fieldCategory],
                                                      name: itemsData.docs[index][ItemModel.fieldName],
                                                    ),
                                                    path: pathItem,
                                                    categoryList: categoriesList,
                                                  ),
                                                  "title": "New Item",
                                                });
                                            break;
                                          case ExpenseEntryMode.delete:
                                            await DatabaseService(path: pathItem).deleteEntry(itemsData.docs[index].id);
                                            break;
                                        }
                                      },
                                      popUpMenuItemList: const [
                                        PopupMenuItem<ExpenseEntryMode>(
                                            value: ExpenseEntryMode.edit,
                                            child: Text("Edit")
                                        ),
                                        PopupMenuItem<ExpenseEntryMode>(
                                            value: ExpenseEntryMode.delete,
                                            child: Text("Delete")
                                        ),
                                      ],

                                    );
                                  }
                              );
                            }
                            return Center(
                              child: Text("No data found",
                                style: whiteStyle
                              ),
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        else {
          return const Loading();
        }
      }
    );
  }

  Stream<String> calculateSum(QuerySnapshot<ItemModel>? items) async* {
    var formatter = NumberFormat('###,###,##0.00');
    double sum = 0;
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++){
      sum = sum + double.parse(items?.docs[i][ItemModel.fieldAmount]);
    }

    yield formatter.format(sum).toString();
  }

}
