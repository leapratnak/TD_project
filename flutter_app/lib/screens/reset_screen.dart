import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/responsive_form.dart';
import '../services/api_service.dart';

class ResetScreen extends StatefulWidget {
  final String email;
  const ResetScreen({Key? key, required this.email}) : super(key: key);

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
    setState(() => _secondsRemaining = seconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
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
        _startCountdown(60);
      } else {
        final errorMessage =
            res['body']?['error']?.toString() ?? 'Error sending OTP';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
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
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        final errorMessage =
            res['body']?['error']?.toString() ?? 'Error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: ResponsiveForm(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.password, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Text(
              "Reset password for\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _otp,
              decoration: const InputDecoration(
                labelText: "OTP",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _newPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 12),
            if (_secondsRemaining > 0)
              Text(
                'You can resend OTP in $_secondsRemaining s',
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _reset,
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
                        "Reset Password",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed:
                  _secondsRemaining == 0 && !_loading ? _sendOTP : null,
              child: const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
