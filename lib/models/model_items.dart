class ItemModel {
  final String name;
  final String category;
  final String transDate;
  final double amount;
  final String year;
  final String month;
  final String day;

  ItemModel({this.year="", this.month="", this.day="", this.amount=0, this.transDate="", this.name="", this.category=""});

  static const String fieldName = "ITEM_NAME";
  static const String fieldCategory = "CATEGORY";
  static const String fieldDate = "TRANS_DATE";
  static const String fieldAmount = "AMOUNT";
  static const String fieldYear = "YEAR";
  static const String fieldMonth = "MONTH";
  static const String fieldDay = "DAY";

  ItemModel.fromJson(Map<String, Object?> json) :
        this(
          name: json[fieldName] as String,
          category: json[fieldCategory] as String,
          transDate: json[fieldDate] as String,
          amount: json[fieldAmount] as double,
          year : json[fieldYear] as String,
          month : json[fieldMonth] as String,
          day : json[fieldDay] as String
      );

  Map<String, Object?> toJson() {
    return {
      fieldName : name,
      fieldCategory : category,
      fieldDate : transDate,
      fieldAmount : amount,
      fieldYear : year,
      fieldMonth : month,
      fieldDay : day
    };
  }

}