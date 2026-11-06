class RegisterRequest {
  final String fullName;
  final String academicId;
  final String email;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });
}
