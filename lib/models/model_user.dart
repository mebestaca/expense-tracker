class UserModel{
  final String uid;
  final String firstName;
  final String lastName;

  UserModel({this.uid="", this.firstName="", this.lastName=""});

  static const String fieldUID = "UID";
  static const String fieldFIRSTNAME = "FIRST_NAME";
  static const String fieldLASTNAME = "LAST_NAME";
  static const String fieldID = "ID";


  UserModel.fromJson(Map<String, Object?> json) :
        this(
          uid: json[fieldUID] as String,
          firstName: json[fieldFIRSTNAME] as String,
          lastName: json[fieldLASTNAME] as String
      );

  Map<String, Object?> toJson() {
    return {
      fieldUID : uid,
      fieldFIRSTNAME : firstName,
      fieldLASTNAME : lastName
    };
  }

}