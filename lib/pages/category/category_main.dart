import 'package:expense_tracker/constants/paths.dart';
import 'package:expense_tracker/extensions/user_model_extension.dart';
import 'package:expense_tracker/pages/category/category_list.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/model_user.dart';
import '../../shared/widgets/loading_screen.dart';

class CategoryMain extends StatefulWidget {
  const CategoryMain({Key? key}) : super(key: key);

  @override
  State<CategoryMain> createState() => _CategoryMainState();
}

class _CategoryMainState extends State<CategoryMain> {

  @override
  Widget build(BuildContext context) {

    final loginInfo = Provider.of<UserModel?>(context, listen: false);

    return FutureBuilder(
        future: DatabaseService(path: Paths.users).getUserModelReference().
            queryBy(UserQueryModes.userData, filter: loginInfo?.uid ?? "").get(),
        builder: (context, user) {

            if (user.hasData) {
                final userData = user.requireData;

                String path = "${Paths.users}/${userData.docs[0].id}/${Paths.category}";

                if (userData.size > 0) {
                    return CategoryList(path: path);
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
