import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_request.dart';
import '../../utils/form_validators.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final AuthController controller;
  const LoginPage({super.key, required this.controller});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.controller.login(LoginRequest(
      identifier: _identifier.text.trim(),
      password: _password.text,
      rememberMe: _rememberMe,
    ));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? 'تم تسجيل الدخول بنجاح' :
          widget.controller.errorMessage ?? 'تعذر تسجيل الدخول'),
      backgroundColor: success ? Colors.green : Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('تسجيل الدخول'), centerTitle: true),
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
                    const Icon(Icons.school, size: 76, color: Colors.indigo),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _identifier,
                      decoration: const InputDecoration(
                        labelText: 'المعرف الأكاديمي أو البريد',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: FormValidators.loginIdentifier,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility :
                              Icons.visibility_off),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: FormValidators.loginPassword,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('تذكرني'),
                      value: _rememberMe,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? false),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) =>
                            ForgotPasswordPage(controller: widget.controller))),
                        child: const Text('نسيت كلمة المرور؟'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: widget.controller.isLoading ? null : _login,
                      child: widget.controller.isLoading
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('تسجيل الدخول'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                          RegisterPage(controller: widget.controller))),
                      child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
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
