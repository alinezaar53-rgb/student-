import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/reset_password_request.dart';
import '../../utils/form_validators.dart';

class ResetPasswordPage extends StatefulWidget {
  final AuthController controller;
  final String identifier;
  const ResetPasswordPage({
    super.key, required this.controller, required this.identifier,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _otp.dispose(); _password.dispose(); _confirm.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.resetPassword(ResetPasswordRequest(
      identifier: widget.identifier,
      otp: _otp.text.trim(),
      newPassword: _password.text,
    ));
    if (!mounted) return;
    if (success) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('تم تحديث كلمة المرور'),
          content: const Text('يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.controller.errorMessage ?? 'فشل تحديث كلمة المرور'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('تعيين كلمة مرور جديدة')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _otp,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'رمز التحقق (6 أرقام)',
                        prefixIcon: Icon(Icons.pin),
                      ),
                      validator: FormValidators.otp,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword ? Icons.visibility :
                            Icons.visibility_off),
                          onPressed: () => setState(() =>
                            _hidePassword = !_hidePassword),
                        ),
                      ),
                      validator: FormValidators.strongPassword,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirm,
                      obscureText: _hideConfirm,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور الجديدة',
                        suffixIcon: IconButton(
                          icon: Icon(_hideConfirm ? Icons.visibility :
                            Icons.visibility_off),
                          onPressed: () => setState(() =>
                            _hideConfirm = !_hideConfirm),
                        ),
                      ),
                      validator: (value) =>
                        FormValidators.confirmPassword(value, _password.text),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: widget.controller.isLoading ? null : _reset,
                      child: widget.controller.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('تحديث كلمة المرور'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
