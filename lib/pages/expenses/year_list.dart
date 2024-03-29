import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/constants/months.dart';
import 'package:expense_tracker/extensions/item_model_extension.dart';
import 'package:expense_tracker/shared/white_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/paths.dart';
import '../../constants/routes.dart';
import '../../models/model_items.dart';
import '../../services/database.dart';
import '../../shared/widgets/generic_list_tile.dart';
import '../../shared/widgets/loading_screen.dart';
import 'month_list.dart';

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

    String pathItem = "${widget.path}${Paths.items}";

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
                              Navigator.pushNamed(context, Routes.genericRoute, arguments: {
                                "widget" : MonthList(
                                  year: widget.year,
                                  path: widget.path,
                                  month: monthListData[index],
                                ),
                                "title" : intToMonth[int.parse(monthListData[index])-1]
                              });
                            },
                            child: StreamBuilder(
                              stream: getMonthTotal(itemsData, widget.year, monthListData![index]),
                              builder: (context, sum){
                                if (sum.hasData) {
                                  final sumData = sum.data;

                                  return GenericListTile(
                                    id: "",
                                    path: "",
                                    title: intToMonth[int.parse(monthListData[index])-1],
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
                              },
                            ),
                          );
                        }
                    );
                  }
                  else{
                    return Center(
                      child: Text("No data found",
                        style: whiteStyle,
                      ),
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
      list.add(items?.docs[i][ItemModel.fieldMonth]);
    }

    yield list.toSet().toList();
  }

  Stream<String> getMonthTotal(QuerySnapshot<ItemModel>? items, String year, String month) async*{
    var formatter = NumberFormat('###,###,##0.00');
    double sum = 0;
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++) {
      if (items?.docs[i][ItemModel.fieldYear] == year &&
          items?.docs[i][ItemModel.fieldMonth] == month){
        sum = sum + double.parse(items?.docs[i][ItemModel.fieldAmount]);
      }
    }

    yield formatter.format(sum).toString();
  }

}
