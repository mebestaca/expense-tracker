import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/model_category.dart';
import 'package:expense_tracker/models/model_user.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference _ref;
  String path;

  DatabaseService({this.path = "", }) {
    _ref = _firebaseFirestore.collection(path);
  }

  Future addEntry(Map<String, dynamic> data) async {
    return await _ref.add(data);
  }

  Future updateEntry(Map<String, dynamic> data, String id) async {
    return await _ref.doc(id).update(data);
  }

  Future deleteEntry(String id) async {
    return await _ref.doc(id).delete();
  }

  CollectionReference<UserModel> getUserModelReference() {
    return _ref.withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  CollectionReference<CategoryModel> getCategoryModelReference() {
    return _ref.withConverter<CategoryModel>(
        fromFirestore: (snapshot, _) => CategoryModel.fromJson(snapshot.data()!),
        toFirestore: (category, _) => category.toJson());
  }

}