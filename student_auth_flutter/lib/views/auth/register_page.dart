import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/register_request.dart';
import '../../utils/form_validators.dart';

class RegisterPage extends StatefulWidget {
  final AuthController controller;
  const RegisterPage({super.key, required this.controller});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _academicId = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _accepted = false;
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _name.dispose(); _academicId.dispose(); _email.dispose();
    _password.dispose(); _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على اللوائح والشروط الأكاديمية')),
      );
      return;
    }
    final success = await widget.controller.register(RegisterRequest(
      fullName: _name.text.trim(),
      academicId: _academicId.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    ));
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحساب بنجاح'),
          backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.controller.errorMessage ?? 'فشل إنشاء الحساب'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('إنشاء حساب جديد')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: _name,
                      decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                      validator: FormValidators.fullName),
                    const SizedBox(height: 14),
                    TextFormField(controller: _academicId,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'الرقم الأكاديمي'),
                      validator: FormValidators.academicId),
                    const SizedBox(height: 14),
                    TextFormField(controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'البريد الجامعي'),
                      validator: FormValidators.universityEmail),
                    const SizedBox(height: 14),
                    TextFormField(controller: _password,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(labelText: 'كلمة المرور',
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword ? Icons.visibility :
                            Icons.visibility_off),
                          onPressed: () => setState(() =>
                            _hidePassword = !_hidePassword))),
                      validator: FormValidators.strongPassword),
                    const SizedBox(height: 14),
                    TextFormField(controller: _confirm,
                      obscureText: _hideConfirm,
                      decoration: InputDecoration(labelText: 'تأكيد كلمة المرور',
                        suffixIcon: IconButton(
                          icon: Icon(_hideConfirm ? Icons.visibility :
                            Icons.visibility_off),
                          onPressed: () => setState(() =>
                            _hideConfirm = !_hideConfirm))),
                      validator: (value) =>
                        FormValidators.confirmPassword(value, _password.text)),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _accepted,
                      onChanged: (value) =>
                        setState(() => _accepted = value ?? false),
                      title: const Text('أوافق على اللوائح والشروط الأكاديمية'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity,
                      child: FilledButton(
                        onPressed: widget.controller.isLoading ? null : _register,
                        child: widget.controller.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('إنشاء الحساب'),
                      )),
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
