import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';

abstract class AuthRepository {
  Future<bool> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
  Future<bool> sendPasswordResetCode(String identifier);
  Future<bool> resetPassword(ResetPasswordRequest request);
}
