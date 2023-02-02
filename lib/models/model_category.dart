class CategoryModel{
  final String uid;
  final String category;

  CategoryModel({this.uid = "", this.category = ""});

  static const String fieldUID = "UID";
  static const String fieldCATEGORY = "CATEGORY";

  CategoryModel.fromJson(Map<String, Object?> json):
      this(
        uid : json[fieldUID] as String,
        category : json[fieldCATEGORY] as String
      );

  Map<String, Object?> toJson() {
    return {
      fieldUID : uid,
      fieldCATEGORY : category
    };
  }
}