import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/model_user.dart';

enum UserQueryModes {
  userData
}

extension UserQuery on Query<UserModel> {
  Query<UserModel> queryBy(UserQueryModes query, {String filter = ""}) {
    switch (query) {
      case UserQueryModes.userData:
        return where(UserModel.fieldUID, isEqualTo: filter);
    }
  }
}