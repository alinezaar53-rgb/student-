import 'package:flutter/foundation.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/reset_password_request.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  AuthController(this.repository);

  void _start() {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  void _finish() {
    isLoading = false;
    notifyListeners();
  }

  Future<bool> login(LoginRequest request) async {
    _start();
    try {
      final result = await repository.login(request);
      if (!result) errorMessage = 'بيانات الدخول غير صحيحة';
      if (result) successMessage = 'تم تسجيل الدخول بنجاح';
      return result;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _start();
    try {
      await repository.register(request);
      successMessage = 'تم إنشاء الحساب بنجاح';
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> sendPasswordResetCode(String identifier) async {
    _start();
    try {
      final result = await repository.sendPasswordResetCode(identifier);
      if (result) {
        successMessage = 'تم إرسال رمز التحقق (الرمز التجريبي: 123456)';
      } else {
        errorMessage = 'لم يتم العثور على حساب بهذه البيانات';
      }
      return result;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> resetPassword(ResetPasswordRequest request) async {
    _start();
    try {
      final result = await repository.resetPassword(request);
      if (result) {
        successMessage = 'تم تحديث كلمة المرور بنجاح';
      } else {
        errorMessage = 'رمز التحقق غير صحيح أو انتهت صلاحيته';
      }
      return result;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _finish();
    }
  }
}
