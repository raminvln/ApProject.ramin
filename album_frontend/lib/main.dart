import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدیریت آلبوم عکس',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عنوان
              const Text(
                'گالری عکس',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              
              // فیلد نام کاربری
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'نام کاربری',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              // فیلد رمز عبور
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'رمز عبور',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              
              // دکمه ورود
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ورود',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // لینک ثبت‌نام
              TextButton(
                onPressed: () {
                  // TODO: رفتن به صفحه ثبت‌نام
                },
                child: const Text('ثبت‌نام نکرده‌اید؟ کلیک کنید'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    
    // موقتاً با داده‌های ثابت چک می‌کنیم
    if (username == 'admin' && password == 'Admin123') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ورود موفقیت‌آمیز بود!')),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('خطا'),
          content: const Text('نام کاربری یا رمز عبور اشتباه است'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('باشه'),
            ),
          ],
        ),
      );
    }
  }
}