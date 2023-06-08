import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/paths.dart';
import '../../extensions/item_model_extension.dart';
import '../../extensions/user_model_extension.dart';
import '../../models/model_chart.dart';
import '../../models/model_items.dart';
import '../../models/model_user.dart';
import '../../shared/widgets/loading_screen.dart';

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

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
    final loginInfo = Provider.of<UserModel?>(context, listen: false);

    return FutureBuilder(
        future: DatabaseService(path: Paths.users).getUserModelReference().
        queryBy(UserQueryModes.userData, filter: loginInfo?.uid ?? "").get(),
        builder: (context, user) {
          if (user.hasData) {
            final userData = user.requireData;
            String pathItems = "${Paths.users}/${userData.docs[0].id}/${Paths.items}";
            String pathCategories = "${Paths.users}/${userData.docs[0].id}/${Paths.category}";

            return StreamBuilder(
              stream: DatabaseService(path: pathCategories).getCategoryModelReference().snapshots(),
              builder: (context, categories) {
                if (categories.hasData) {
                  final categoriesData = categories.requireData;

                  List<String> categoriesList = categoriesData.docs.map((
                      docs) {
                    return docs.data().category;
                  }).toList();
                  categoriesList.add("Uncategorized");
                  categoriesList = categoriesList.toSet().toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          child: ExpansionTile(
                            title: const Text("Today"),
                            children: [
                              const Divider(thickness: 1),
                              StreamBuilder(
                                  stream: DatabaseService(path: pathItems).getItemModelReference().
                                  queryBy(ItemQueryModes.today, filter: transDate).snapshots(),
                                  builder: (context, item) {

                                    if (item.hasData) {
                                      final itemData = item.data;

                                      return StreamBuilder(
                                        stream: convertToChartData(itemData, categoriesList),
                                        builder: (context, chart) {

                                          if (chart.hasData) {
                                            final chartData = chart.data;
                                            if (chartData!.length > 0) {
                                              return SfCircularChart(
                                                  annotations: [
                                                    CircularChartAnnotation(
                                                        widget: const Text("Categories")
                                                    )
                                                  ],
                                                  legend: Legend(
                                                    isVisible: true,
                                                  ),
                                                  series: <CircularSeries<ChartData, String>>[
                                                    DoughnutSeries<ChartData, String>(
                                                        dataSource: chartData,
                                                        xValueMapper: (ChartData data, _) => data.name,
                                                        yValueMapper: (ChartData data, _) => data.amount,
                                                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                        explode: true,
                                                        explodeAll: true,
                                                        explodeOffset: "3"),

                                                  ]
                                              );
                                            }
                                            else{
                                              return const Center(
                                                child: Text("No Data"),
                                              );
                                            }

                                          }
                                          else {
                                            return const Loading();
                                          }
                                        },
                                      );
                                    }
                                    else{
                                      return const Center(
                                        child: Text("No Data"),
                                      );
                                    }
                                  }
                              )
                            ],
                          ),
                        ),
                        Card(
                          child: ExpansionTile(
                            title: const Text("This Month"),
                            children: [
                              const Divider(thickness: 1),
                              StreamBuilder(
                                  stream: DatabaseService(path: pathItems).getItemModelReference().
                                  queryBy(ItemQueryModes.month, filter: "${transDate.substring(0,4)}${transDate.substring(5,7)}").snapshots(),
                                  builder: (context, item) {

                                    if (item.hasData) {
                                      final itemData = item.data;

                                      return StreamBuilder(
                                        stream: convertToChartData(itemData, categoriesList),
                                        builder: (context, chart) {

                                          if (chart.hasData) {
                                            final chartData = chart.data;

                                            if (chartData!.length > 0) {
                                              return SfCircularChart(
                                                  annotations: [
                                                    CircularChartAnnotation(
                                                        widget: const Text("Categories")
                                                    )
                                                  ],
                                                  legend: Legend(
                                                    isVisible: true,
                                                  ),
                                                  series: <CircularSeries<ChartData, String>>[
                                                    DoughnutSeries<ChartData, String>(
                                                        dataSource: chartData,
                                                        xValueMapper: (ChartData data, _) => data.name,
                                                        yValueMapper: (ChartData data, _) => data.amount,
                                                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                        explode: true,
                                                        explodeAll: true,
                                                        explodeOffset: "3"),

                                                  ]
                                              );
                                            }
                                            else {
                                              return const Center(
                                                child: Text("No Data"),
                                              );
                                            }

                                          }
                                          else {
                                            return const Loading();
                                          }
                                        },
                                      );
                                    }
                                    else{
                                      return const Center(
                                        child: Text("No Data"),
                                      );
                                    }
                                  }
                              )
                            ],
                          ),
                        ),
                        Card(
                          child: ExpansionTile(

                            title: const Text("This Year"),
                            children: [
                              const Divider(thickness: 1),
                              StreamBuilder(
                                  stream: DatabaseService(path: pathItems).getItemModelReference().
                                  queryBy(ItemQueryModes.year, filter: transDate.substring(0,4)).snapshots(),
                                  builder: (context, item) {

                                    if (item.hasData) {
                                      final itemData = item.data;

                                      return StreamBuilder(
                                        stream: convertToChartData(itemData, categoriesList),
                                        builder: (context, chart) {

                                          if (chart.hasData) {
                                            final chartData = chart.data;

                                            if (chartData!.length > 0) {
                                              return SfCircularChart(
                                                  annotations: [
                                                    CircularChartAnnotation(
                                                        widget: const Text("Categories")
                                                    )
                                                  ],
                                                  legend: Legend(
                                                    isVisible: true,
                                                  ),
                                                  series: <CircularSeries<ChartData, String>>[
                                                    DoughnutSeries<ChartData, String>(
                                                        dataSource: chartData,
                                                        xValueMapper: (ChartData data, _) => data.name,
                                                        yValueMapper: (ChartData data, _) => data.amount,
                                                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                                                        explode: true,
                                                        explodeAll: true,
                                                        explodeOffset: "3"),

                                                  ]
                                              );
                                            }
                                            else {
                                              return const Center(
                                                child: Text("No Data"),
                                              );
                                            }

                                          }
                                          else {
                                            return const Loading();
                                          }
                                        },
                                      );
                                    }
                                    else{
                                      return const Center(
                                        child: Text("No Data"),
                                      );
                                    }
                                  }
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                else{
                  return const Loading();
                }
              }
            );
          }
          else {
            return const Loading();
          }
        }
    );
  }


  Stream<List<ChartData>> convertToChartData(QuerySnapshot<ItemModel>? items, List<String> categoryList) async*{

    List<ChartData> chartData = [];
    final itemsData = items?.docs.length ?? 0;
    for(String category in categoryList) {
      double sum = 0;
      for(int i = 0; i < itemsData; i++) {
        if (items?.docs[i][ItemModel.fieldCategory] == category){
          sum = sum + double.parse(items?.docs[i][ItemModel.fieldAmount]);
        }
      }
      ChartData data = ChartData(
          name:  category,
          amount:  sum
      );
      chartData.add(data);
    }

    chartData.removeWhere((e) => e.amount == 0);

    yield chartData;
  }
}
