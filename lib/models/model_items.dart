class ItemModel {
  final String uid;
  final String id;
  final String name;
  final String category;

  ItemModel(this.uid, this.id, this.name, this.category);

  static const String fieldUid = "UID";
  static const String fieldId = "ID";
  static const String fieldName = "ITEM_NAME";
  static const String fieldCategory = "CATEGORY";

}