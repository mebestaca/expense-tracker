import 'package:expense_tracker/pages/expenses/history_list.dart';
import 'package:expense_tracker/pages/expenses/today_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/paths.dart';
import '../../extensions/user_model_extension.dart';
import '../../models/model_user.dart';
import '../../pages/category/category_list.dart';
import '../../pages/charts/charts.dart';
import '../../services/database.dart';
import 'loading_screen.dart';


enum Pages {
  dashboard,
  today,
  history,
  category
}

class GenericPathfinder extends StatefulWidget {
  const GenericPathfinder({Key? key, required this.pages}) : super(key: key);

  final Pages pages;

  @override
  State<GenericPathfinder> createState() => _GenericPathfinderState();
}

class _GenericPathfinderState extends State<GenericPathfinder> {
  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<UserModel?>(context, listen: false);

    return FutureBuilder(
        future: DatabaseService(path: Paths.users).getUserModelReference().
        queryBy(UserQueryModes.userData, filter: loginInfo?.uid ?? "").get(),
        builder: (context, user) {

          if (user.hasData) {
            final userData = user.requireData;

            if (userData.size > 0) {
              switch(widget.pages){
                case Pages.dashboard:
                  return const Charts();
                case Pages.today:
                  String path = "${Paths.users}/${userData.docs[0].id}/";
                  return TodayList(path: path);
                case Pages.history:
                  String path = "${Paths.users}/${userData.docs[0].id}/";
                  return HistoryList(path: path);
                case Pages.category:
                  String path = "${Paths.users}/${userData.docs[0].id}/${Paths.category}";
                  return CategoryList(path: path);
              }
            }
            else {
              return const Center(
                child: Text("User data is missing"),
              );
            }
          }
          else {
            return const Loading();
          }
        }
    );
  }
}
