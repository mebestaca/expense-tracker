import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model_items.dart';

enum ItemQueryModes{
  today
}

extension ItemQuery on Query<ItemModel> {
  Query<ItemModel> queryBy(ItemQueryModes query, {String filter=""}) {
    switch(query) {
      case ItemQueryModes.today:
        return where(ItemModel.fieldDate, isEqualTo: filter);
    }
  }
}