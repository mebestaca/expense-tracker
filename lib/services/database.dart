import 'package:cloud_firestore/cloud_firestore.dart';

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

  /*
  CollectionReference<ItemModel> getItemModelReference() {
    return _ref.withConverter<ItemModel>(
        fromFirestore: (snapshot, _) => ItemModel.fromJson(snapshot.data()!!),
        toFirestore: (item, _) => item.toJson());
  }
  */
}