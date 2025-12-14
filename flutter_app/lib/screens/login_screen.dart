import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/responsive_form.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrUsername = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    final emailOrUsername = _emailOrUsername.text.trim();
    final password = _password.text.trim();

    if (emailOrUsername.isEmpty || password.isEmpty) {
      setState(() => _error = "Please enter email/username and password");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiService.post('/api/auth/login', {
        'emailOrUsername': emailOrUsername,
        'password': password,
      });

      if (res['status'] == 200 && res['body']?['token'] != null) {
        await ApiService.saveToken(res['body']['token']);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        setState(() {
          _error = res['body']?['error']?.toString() ?? 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = "Something went wrong. Please try again.";
      });
      print("Login error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailOrUsername.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login", style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepPurple, elevation: 0),
      body: ResponsiveForm(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text("Login to your account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            TextField(controller: _emailOrUsername, decoration: const InputDecoration(labelText: "Email or Username", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 12),
            TextField(controller: _password, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)), obscureText: true),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text("Login", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  SignupScreen())), child: const Text("Signup")),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ForgotScreen())), child: const Text("Forgot Password")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
