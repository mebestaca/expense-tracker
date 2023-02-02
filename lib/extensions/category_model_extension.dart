import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model_category.dart';

enum CategoryQueryModes{
  name
}

extension CategoryQuery on Query<CategoryModel> {
  Query<CategoryModel> queryBy(CategoryQueryModes query, {String filter = ""}){
    switch(query) {
      case CategoryQueryModes.name:
        return where(CategoryModel.fieldCATEGORY, isGreaterThanOrEqualTo: filter,
          isLessThanOrEqualTo: "${filter}z").
          orderBy(CategoryModel.fieldCATEGORY, descending: false);
    }
  }
}