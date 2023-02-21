import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/months.dart';
import 'package:expense_tracker/extensions/item_model_extension.dart';
import 'package:flutter/material.dart';

import '../../models/model_items.dart';
import '../../services/database.dart';
import '../../shared/widgets/generic_list_tile.dart';
import '../../shared/widgets/loading_screen.dart';

class YearList extends StatefulWidget {
  const YearList({Key? key, required this.year, required this.path}) : super(key: key);

  final String year;
  final String path;

  @override
  State<YearList> createState() => _YearListState();
}

class _YearListState extends State<YearList> {
  @override
  Widget build(BuildContext context) {

    String pathItem = widget.path;

    return StreamBuilder(
        stream: DatabaseService(path: pathItem).getItemModelReference().
          queryBy(ItemQueryModes.year, filter: widget.year).snapshots(),
        builder: (context, items) {
          if (items.hasData) {
            final itemsData = items.data;

            return StreamBuilder(
                stream: getMonth(itemsData),
                builder: (context, monthList) {
                  if(monthList.hasData) {
                    final monthListData = monthList.data;

                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: monthListData?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              /*
                              Navigator.pushNamed(context, Routes.genericRoute, arguments: {
                                "widget" : YearList(
                                  year:monthListData[index],
                                  path: pathItem,
                                ),
                                "title" : monthListData[index]
                              });
                              */
                            },
                            child: GenericListTile(
                              id: "",
                              path: "",
                              title: monthListData![index],
                              subTitle: "",
                              switchFunction: () {},
                              popUpMenuItemList: const [],
                            ),
                          );
                        }
                    );
                  }
                  else{
                    return const Center(
                      child: Text("No data found"),
                    );
                  }
                }
            );
          }
          else{
            return const Loading();
          }
        }
    );
  }

  Stream<List<String>> getMonth(QuerySnapshot<ItemModel>? items) async* {
    List<String> list = [];
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++){
      String month = intToMonth[int.parse(items?.docs[i][ItemModel.fieldMonth])-1];
      list.add(month);
    }

    yield list.toSet().toList();
  }
}
