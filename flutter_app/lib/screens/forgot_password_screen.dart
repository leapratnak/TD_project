import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reset_screen.dart';

class ForgotScreen extends StatefulWidget {
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _email = TextEditingController();
  bool _loading = false;

  void _sendOTP() async {
    setState(() {
      _loading = true;
    });

    try {
      final res = await ApiService.post('/api/auth/forgot-password', {
        'email': _email.text.trim(),
      });

      setState(() {
        _loading = false;
      });

      if (res['status'] == 200) {
        // Show SnackBar for 20 seconds
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("OTP sent to your email"),
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to reset screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetScreen(email: _email.text.trim()),
          ),
        );
      } else {
        final errorMessage = res['body']?['error']?.toString() ?? 'Error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Something went wrong. Please try again."),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _sendOTP,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
