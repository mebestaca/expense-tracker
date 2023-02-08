class ItemModel {
  final String name;
  final String category;
  final String transDate;
  final double amount;

  ItemModel({this.amount=0, this.transDate="", this.name="", this.category=""});

  static const String fieldName = "ITEM_NAME";
  static const String fieldCategory = "CATEGORY";
  static const String fieldDate = "TRANS_DATE";
  static const String fieldAmount = "AMOUNT";

  ItemModel.fromJson(Map<String, Object?> json) :
        this(
          name: json[fieldName] as String,
          category: json[fieldCategory] as String,
          transDate: json[fieldDate] as String,
          amount: json[fieldAmount] as double
      );

  Map<String, Object?> toJson() {
    return {
      fieldName : name,
      fieldCategory : category,
      fieldDate : transDate,
      fieldAmount : amount,
    };
  }

}