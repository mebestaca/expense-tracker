class CategoryModel{

  final String category;

  CategoryModel({this.category = ""});

  static const String fieldCATEGORY = "CATEGORY";

  CategoryModel.fromJson(Map<String, Object?> json):
      this(
        category : json[fieldCATEGORY] as String
      );

  Map<String, Object?> toJson() {
    return {
      fieldCATEGORY : category
    };
  }
}