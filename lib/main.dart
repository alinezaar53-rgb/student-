import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = AuthController(AuthRepositoryImpl());
  runApp(StudentAuthApp(authController: authController));
}

class StudentAuthApp extends StatelessWidget {
  final AuthController authController;
  const StudentAuthApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Authentication',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: LoginPage(controller: authController),
    );
  }
}
