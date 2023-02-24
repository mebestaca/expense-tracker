import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/pages/expenses/year_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/paths.dart';
import '../../constants/routes.dart';
import '../../models/model_items.dart';
import '../../services/database.dart';
import '../../shared/widgets/generic_list_tile.dart';
import '../../shared/widgets/loading_screen.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {

    String pathItem = "${widget.path}${Paths.items}";

    return StreamBuilder(
      stream: DatabaseService(path: pathItem).getItemModelReference().snapshots(),
      builder: (context, items) {
        if (items.hasData) {
          final itemsData = items.data;
          return StreamBuilder(
            stream: getYear(itemsData),
            builder: (context, yearList) {
              if(yearList.hasData) {
                final yearListData = yearList.data;

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: yearListData?.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.genericRoute, arguments: {
                          "widget" : YearList(
                            year:yearListData[index],
                            path: widget.path,
                          ),
                          "title" : yearListData[index]
                        });
                      },
                      child: StreamBuilder(
                        stream: getYearTotal(itemsData, yearListData![index]),
                        builder: (context, sum) {

                          if (sum.hasData) {
                            final sumData = sum.data;

                            return GenericListTile(
                              id: "",
                              path: "",
                              title: yearListData[index],
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

  Stream<List<String>> getYear(QuerySnapshot<ItemModel>? items) async* {
    List<String> list = [];
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++){
      list.add(items?.docs[i][ItemModel.fieldYear]);
    }

    yield list.toSet().toList();
  }

  Stream<String> getYearTotal(QuerySnapshot<ItemModel>? items, String year) async*{
    var formatter = NumberFormat('###,###,##0.00');
    double sum = 0;
    final itemsData = items?.docs.length ?? 0;

    for(int i = 0; i < itemsData; i++) {
      if (items?.docs[i][ItemModel.fieldYear] == year){
        sum = sum + double.parse(items?.docs[i][ItemModel.fieldAmount]);
      }
    }

    yield formatter.format(sum).toString();
  }
}
