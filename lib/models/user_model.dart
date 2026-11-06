class UserModel {
  final String fullName;
  final String academicId;
  final String email;
  String password;

  UserModel({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });
}
