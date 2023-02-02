import 'package:expense_tracker/constants/paths.dart';
import 'package:expense_tracker/extensions/category_model_extension.dart';
import 'package:expense_tracker/extensions/user_model_extension.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:expense_tracker/shared/text_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/routes.dart';
import '../../models/model_user.dart';
import '../../shared/widgets/loading_screen.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  @override
  Widget build(BuildContext context) {

    String categoryName = "";
    final globalKey = GlobalKey<FormState>();
    final categoryController = TextEditingController();
    final loginInfo = Provider.of<UserModel?>(context, listen: false);

    return FutureBuilder(
        future: DatabaseService(path: Paths.users).getUserModelReference().
            queryBy(UserQueryModes.userData, filter: loginInfo?.uid ?? "").get(),
        builder: (context, user) {
            if (user.hasData) {
                final userData = user.requireData;

                String path = "${Paths.users}/${userData.docs[0].id}/${Paths.category}";

                if (userData.size > 0) {
                    return Column(
                        children: [
                          Container(
                            color: Theme.of(context).canvasColor,
                            child: Form(
                              key: globalKey,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: categoryController,
                                  decoration: fieldStyle.copyWith(
                                      hintText: "category",
                                      labelText: "category",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              categoryName = "";
                                              categoryController.clear();
                                            });
                                          },
                                          icon: categoryName.isNotEmpty ? const Icon(Icons.cancel_outlined) : Container()
                                      )
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      categoryName = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: StreamBuilder(
                                stream: DatabaseService(path: path).getCategoryModelReference().
                                queryBy(CategoryQueryModes.name, filter: categoryName).snapshots(),
                                builder: (context, categories) {
                                  if (user.hasData) {
                                    final categoriesData = categories.requireData;

                                    if (categoriesData.size > 0) {
                                      return ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: categoriesData.size,
                                          itemBuilder: (context, index) {
                                            return const Placeholder();
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
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, Routes.categoryMaintenance);
                                  },
                                  child: Text("Add New Category",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).textScaleFactor * 18
                                    ),
                                  )
                              ),
                            ),
                          )
                        ],
                    );
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
