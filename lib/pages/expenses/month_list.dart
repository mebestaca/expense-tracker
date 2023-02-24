import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/extensions/item_model_extension.dart';
import 'package:expense_tracker/pages/expenses/today_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/paths.dart';
import '../../constants/routes.dart';
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

    String pathItem = "${widget.path}${Paths.items}";

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
                    final dayListData = dayList.data;

                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: dayListData?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.genericRoute, arguments: {
                                "widget" : TodayList(
                                  path: widget.path,
                                  year: widget.year,
                                  month: widget.month,
                                  day: dayListData[index],
                                ),
                                "title" : ''
                              });
                            },
                            child: StreamBuilder(
                              stream: getDayTotal(itemsData, widget.year, widget.month, dayListData![index]),
                              builder: (context, sum) {
                                if (sum.hasData) {
                                  final sumData = sum.data;
                                  return GenericListTile(
                                    id: "",
                                    path: "",
                                    title: dayListData[index],
                                    subTitle: sumData.toString(),
                                    switchFunction: () {},
                                    popUpMenuItemList: const [],
                                  );
                                }
                                else{
                                  return const Center(
                                    child: Text("Calculating"),
                                  );
                                }
                              }
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

  Stream<String> getDayTotal(QuerySnapshot<ItemModel>? items, String year, String month, String day) async*{
    var formatter = NumberFormat('###,###,##0.00');
    double sum = 0;
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++) {
      if (items?.docs[i][ItemModel.fieldYear] == year &&
          items?.docs[i][ItemModel.fieldMonth] == month &&
          items?.docs[i][ItemModel.fieldDay] == day){
        sum = sum + double.parse(items?.docs[i][ItemModel.fieldAmount]);
      }
    }

    yield formatter.format(sum).toString();
  }

}
