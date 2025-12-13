import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
// import 'forgot_password_screen.dart';

class ResetScreen extends StatefulWidget {
  final String email;
  ResetScreen({required this.email});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _otp = TextEditingController();
  final _newPassword = TextEditingController();
  bool _loading = false;
  int _secondsRemaining = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sendOTP();
    _startCountdown(_secondsRemaining);
  }

  @override
  void dispose() {
    _otp.dispose();
    _newPassword.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        // Go back to ForgotScreen when countdown ends
        // if (mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (_) => ForgotScreen()),
        //   );
        // }
      }
    });
  }

  void _sendOTP() async {
    setState(() => _loading = true);

    try {
      final res = await ApiService.post('/api/auth/forgot-password', {
        'email': widget.email,
      });

      setState(() => _loading = false);

      if (res['status'] == 200) {
        final otp = res['body']?['otp'] ?? 'unknown';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent: $otp'),
            duration: const Duration(seconds: 55),
          ),
        );
        _startCountdown(60); // start countdown again
      } else {
        final errorMessage = res['body']?['error']?.toString() ?? 'Error sending OTP';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _reset() async {
    setState(() => _loading = true);

    try {
      final res = await ApiService.post('/api/auth/reset-password', {
        'email': widget.email,
        'otp': _otp.text.trim(),
        'newPassword': _newPassword.text.trim(),
      });

      setState(() => _loading = false);

      if (res['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully. Please login.'),
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst); // back to login
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
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Reset for: ${widget.email}"),
            TextField(
              controller: _otp,
              decoration: const InputDecoration(labelText: "OTP"),
            ),
            TextField(
              controller: _newPassword,
              decoration: const InputDecoration(labelText: "New password"),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (_secondsRemaining > 0)
              Text(
                'You can resend OTP in $_secondsRemaining s',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _reset,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Reset"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _secondsRemaining == 0 && !_loading ? _sendOTP : null,
              child: const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
