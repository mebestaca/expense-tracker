import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/extensions/item_model_extension.dart';
import 'package:flutter/material.dart';

import '../../models/model_items.dart';
import '../../services/database.dart';
import '../../shared/widgets/generic_list_tile.dart';
import '../../shared/widgets/loading_screen.dart';

class MonthList extends StatefulWidget {
  const MonthList({Key? key, required this.year, required this.path, required this.month}) : super(key: key);

  final String year;
  final String month;
  final String path;

  @override
  State<MonthList> createState() => _MonthListState();
}

class _MonthListState extends State<MonthList> {
  @override
  Widget build(BuildContext context) {

    String pathItem = widget.path;

    return StreamBuilder(
        stream: DatabaseService(path: pathItem).getItemModelReference().
        queryBy(ItemQueryModes.month, filter: "${widget.year}${widget.month}").snapshots(),
        builder: (context, items) {
          if (items.hasData) {
            final itemsData = items.data;

            return StreamBuilder(
                stream: getDay(itemsData),
                builder: (context, dayList) {
                  if(dayList.hasData) {
                    final monthListData = dayList.data;

                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: monthListData?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              
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

  Stream<List<String>> getDay(QuerySnapshot<ItemModel>? items) async* {
    List<String> list = [];
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++){
      list.add(items?.docs[i][ItemModel.fieldDay]);
    }

    yield list.toSet().toList();
  }
}