import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final List<UserModel> _users = [];
  String? _resetIdentifier;

  // محاكاة اتصال الشبكة دون استخدام أي حزمة خارجية.
  Future<void> _simulateNetwork() =>
      Future.delayed(const Duration(seconds: 1));

  @override
  Future<bool> login(LoginRequest request) async {
    await _simulateNetwork();
    final user = _findUser(request.identifier);
    return user != null && user.password == request.password;
  }

  @override
  Future<void> register(RegisterRequest request) async {
    await _simulateNetwork();

    final alreadyExists = _users.any((user) =>
        user.academicId == request.academicId || user.email == request.email);

    if (alreadyExists) {
      throw Exception('الرقم الأكاديمي أو البريد مسجل مسبقاً');
    }

    _users.add(UserModel(
      fullName: request.fullName,
      academicId: request.academicId,
      email: request.email,
      password: request.password,
    ));
  }

  @override
  Future<bool> sendPasswordResetCode(String identifier) async {
    await _simulateNetwork();
    final user = _findUser(identifier);
    if (user == null) return false;
    _resetIdentifier = identifier;
    // رمز تجريبي ثابت: 123456. في النظام الحقيقي يُرسل الرمز للمستخدم.
    return true;
  }

  @override
  Future<bool> resetPassword(ResetPasswordRequest request) async {
    await _simulateNetwork();
    if (request.otp != '123456' || _resetIdentifier != request.identifier) {
      return false;
    }

    final user = _findUser(request.identifier);
    if (user == null) return false;

    user.password = request.newPassword;
    _resetIdentifier = null;
    return true;
  }

  UserModel? _findUser(String identifier) {
    for (final user in _users) {
      if (user.email == identifier || user.academicId == identifier) {
        return user;
      }
    }
    return null;
  }
}
