import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController controller;
  const ForgotPasswordPage({super.key, required this.controller});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();

  @override
  void dispose() {
    _identifier.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    final identifier = _identifier.text.trim();
    final success = await widget.controller.sendPasswordResetCode(identifier);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.controller.successMessage ?? 'تم إرسال رمز التحقق'),
        backgroundColor: Colors.green,
      ));
      Navigator.push(context, MaterialPageRoute(builder: (_) =>
        ResetPasswordPage(controller: widget.controller, identifier: identifier)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.controller.errorMessage ?? 'تعذر إرسال الرمز'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('استعادة كلمة المرور')),
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
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(children: [
                          Icon(Icons.mark_email_read_outlined,
                            size: 44, color: Colors.indigo),
                          SizedBox(height: 8),
                          Text('سنرسل رمز تحقق إلى حسابك المسجل. '
                            'أدخل بريدك الجامعي أو رقمك الأكاديمي للمتابعة.',
                            textAlign: TextAlign.center),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _identifier,
                      decoration: const InputDecoration(
                        labelText: 'البريد أو الرقم الأكاديمي',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: FormValidators.resetIdentifier,
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: widget.controller.isLoading ? null : _sendCode,
                      child: widget.controller.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('إرسال رمز التحقق'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('العودة لتسجيل الدخول'),
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
