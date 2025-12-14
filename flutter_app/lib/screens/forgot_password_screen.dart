import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/responsive_form.dart';
import '../services/api_service.dart';
import 'reset_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _email = TextEditingController();
  bool _loading = false;
  String? _error;

  void _sendOTP() async {
    if (_email.text.trim().isEmpty) {
      setState(() => _error = "Please enter your email");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiService.post('/api/auth/forgot-password', {
        'email': _email.text.trim(),
      });

      if (res['status'] == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP sent to your email")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetScreen(email: _email.text.trim()),
          ),
        );
      } else {
        setState(() {
          _error = res['body']?['error']?.toString() ?? 'Failed to send OTP';
        });
      }
    } catch (e) {
      setState(() => _error = "Something went wrong. Try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: ResponsiveForm(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock_reset, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Reset your password",
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
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _sendOTP,
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
                    : const Text("Send OTP", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
