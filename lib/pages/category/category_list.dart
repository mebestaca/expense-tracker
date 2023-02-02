import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../extensions/category_model_extension.dart';
import '../../models/model_category.dart';
import '../../services/database.dart';
import '../../shared/text_decoration.dart';
import '../../shared/widgets/category_data_entry.dart';
import '../../shared/widgets/loading_screen.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  String categoryName = "";
  final globalKey = GlobalKey<FormState>();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {

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
                    labelText: "search",
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
        Expanded(
          child: StreamBuilder(
              stream: DatabaseService(path: widget.path).getCategoryModelReference().
              queryBy(CategoryQueryModes.name, filter: categoryName).snapshots(),
              builder: (context, categories) {

                if (categories.hasData) {
                  final categoriesData = categories.requireData;

                  if (categoriesData.size > 0) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: categoriesData.size,
                        itemBuilder: (context, index) {
                          return Text(categoriesData.docs[index][CategoryModel.fieldCATEGORY]);
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
                  Navigator.pushNamed(context, Routes.categoryMaintenance,
                      arguments: {
                        "widget" : CategoryDataEntry(
                          entryMode: CategoryEntryMode.add,
                          id: "",
                          model: CategoryModel(),
                          path: widget.path,
                        ),
                        "title" : "New Category",
                      }
                  );
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
}
