import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _isValidUserName(String userName) {
    final emailPattern = RegExp(r'^[A-Za-z0-9+_.-]+@(.+)$');
    final phonePattern = RegExp(r'^0[0-9]{10}$');
    return emailPattern.hasMatch(userName) || phonePattern.hasMatch(userName);
  }

  bool _isValidPassword(String password, String userName) {
    if (password.length < 8) {
      _showError('Password must be at least 8 characters');
      return false;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _showError('Password must contain at least one uppercase letter');
      return false;
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      _showError('Password must contain at least one lowercase letter');
      return false;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _showError('Password must contain at least one digit');
      return false;
    }
    if (password.toLowerCase().contains(userName.toLowerCase().split('@')[0]) &&
        userName.contains('@')) {
      _showError('Password cannot contain your username');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _signUp() {
    String displayName = _displayNameController.text.trim();
    String userName = _userNameController.text.trim();
    String password = _passwordController.text;

    // چک خالی بودن
    if (displayName.isEmpty || userName.isEmpty || password.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    // چک فرمت userName
    if (!_isValidUserName(userName)) {
      _showError('Invalid email or phone format');
      return;
    }

    // چک فرمت password
    if (!_isValidPassword(password, userName)) {
      return;
    }

    // TODO: ذخیره کاربر و رفتن به صفحه اصلی
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB)
                                .withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.photo_camera,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'PhotoVault',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage Memories',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _userNameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email or Phone',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTapDown: (_) => _onTapDown(),
                      onTapUp: (_) => _onTapUp(),
                      onTap: _signUp,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        transform: Matrix4.identity()..scale(_buttonScale),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB)
                                    .withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _buttonScale = 1.0;

  void _onTapDown() {
    setState(() => _buttonScale = 0.98);
  }

  void _onTapUp() {
    setState(() => _buttonScale = 1.0);
  }
}