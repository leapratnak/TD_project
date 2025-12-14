import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/widgets/responsive_form.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _loading = false;       // button loading
  bool _screenLoading = false; // full screen loading
  String? _error;

  void _signup() async {
    final email = _email.text.trim();
    final username = _username.text.trim();
    final password = _password.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() => _error = "All fields are required");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiService.post('/api/auth/signup', {
        'email': email,
        'username': username,
        'password': password,
      });

      if (res['status'] == 201) {
        if (res['body']?['token'] != null) {
          await ApiService.saveToken(res['body']['token']);
        }

        if (!mounted) return;

        // ✅ SHOW SUCCESS ALERT
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully. Please login."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // ✅ SHOW FULL SCREEN LOADING
        setState(() => _screenLoading = true);

        // ✅ WAIT FOR ALERT TO END
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        });
      } else {
        setState(() {
          _error = res['body']?['error']?.toString() ?? 'Signup failed';
        });
      }
    } catch (e) {
      setState(() => _error = "Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Signup", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.deepPurple,
            elevation: 0,
          ),
          body: ResponsiveForm(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.person_add, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 20),
                const Text(
                  "Create your account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _password,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 12),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Signup",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),

        // ✅ FULL SCREEN LOADING OVERLAY
        if (_screenLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
