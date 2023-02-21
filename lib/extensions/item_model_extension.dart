import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model_items.dart';

enum ItemQueryModes{
  today,
  year,
  month
}

extension ItemQuery on Query<ItemModel> {
  Query<ItemModel> queryBy(ItemQueryModes query, {String filter=""}) {
    switch(query) {
      case ItemQueryModes.today:
        return where(ItemModel.fieldDate, isEqualTo: filter).
          orderBy(ItemModel.fieldName, descending: false);
      case ItemQueryModes.year:
        return where(ItemModel.fieldYear, isEqualTo: filter).
          orderBy(ItemModel.fieldMonth, descending: false);
      case ItemQueryModes.month:
        return where(ItemModel.fieldYear, isEqualTo: filter.substring(0,4)).
            where(ItemModel.fieldMonth, isEqualTo: filter.substring(4,6)).
            orderBy(ItemModel.fieldDay, descending: false);
    }
  }
}